// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;
import "./ptoken.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {IERC7527Factory, AgencySettings, AppSettings} from "./EIP7527/src/interfaces/IERC7527Factory.sol";
import {ERC7527Factory} from "./EIP7527/src/ERC7527.sol";
import {IERC7527App} from "./EIP7527/src/interfaces/IERC7527App.sol";
import {IERC7527Agency, Asset} from "./EIP7527/src/interfaces/IERC7527Agency.sol";
import {ERC3525} from "./ERC3525/ERC3525.sol";
// 先部署factory，然后拿到factory去部署app和agency
contract usePtokenWith7527 is ReentrancyGuard{
    address public appInstance;
    address public agencyInstance;
    address public ptokenInstance;
    address public ERC3525SFT;
    IERC7527Factory public erc7527FactoryAddr;
    mapping (address=>bool) isMerchant;
    mapping(address=>uint) burnedPtoken;
    mapping(address => bool) isWraped;
    constructor(
        address _ptokenInstance,
        address _ERC3525SFT,
        IERC7527Factory _erc7527FactoryAddr
        ){
        ERC3525SFT = _ERC3525SFT;
        erc7527FactoryAddr = _erc7527FactoryAddr;
        ptokenInstance = _ptokenInstance;
    }
    // AgencySettings agencySettings = 
    function useDeployWrap(
        AgencySettings calldata agencySettings, 
        AppSettings calldata appSettings,
        bytes calldata
        ) external { 
        (appInstance,agencyInstance) = erc7527FactoryAddr.deployWrap(agencySettings,appSettings,"");
    }

    function useWrap(uint256 targetTokenId) external payable returns(uint256) {
        require(msg.value > 0,"Invalid value");
        address addr = address(this);
        ( ,bytes memory returndata) = agencyInstance.call{value: msg.value}( 
            abi.encodeWithSignature("function wrap(address, bytes)",addr,abi.encode(targetTokenId))
        );
        isWraped[msg.sender]= true;
        return abi.decode(returndata,(uint256));
        
    }

    function useUnWrap(uint256 targetTokenId) external payable {
        require(msg.value > 0,"Invalid value");
        address addr = address(this);
        (bool success, ) = agencyInstance.call{value: msg.value}(
            abi.encodeWithSignature("function unwrap(address, uint256, bytes)",addr,targetTokenId,"")
        );
        require(success, "unWrap failed");
        isWraped[msg.sender]= false;
    }
    function transferSFT(uint256 tokenId, uint256 value,address to) external {
        require(isWraped[msg.sender],"not wraped");
        (bool success, ) = ERC3525SFT.call(
            abi.encodeWithSignature("function transferFrom(uint256,address,uint256)",tokenId,to,value);
        )
        require(success, "failed");
    }

}