// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;
import {IERC7527Factory, AgencySettings, AppSettings} from "./src/interfaces/IERC7527Factory.sol";
import {ERC7527Factory} from "./src/ERC7527.sol";
import {IERC7527App} from "./src/interfaces/IERC7527App.sol";
import {IERC7527Agency, Asset} from "./src/interfaces/IERC7527Agency.sol";
contract useERC7527Factory{ 
    address public appInstance;
    address public agencyInstance;
    bytes public warpReturn;
    bytes public unwarpReturn;
    function useDeployWrap(
        address ERC7527FactoryAddr,
        AgencySettings calldata agencySettings, 
        AppSettings calldata appSettings,
        bytes calldata
        ) external { 
        IERC7527Factory _ERC7527Fac = IERC7527Factory(ERC7527FactoryAddr); 
        (appInstance,agencyInstance)=_ERC7527Fac.deployWrap(agencySettings,appSettings,"");
    }
    function testWarp() public { 
        address addr = address(this);
        ( ,bytes memory returndata) = agencyInstance.call{value: 0.5 ether}( 
            abi.encodeWithSignature("function wrap(address, bytes)",addr,abi.encode(uint256(1)))
        );  
        warpReturn = returndata;
    }
    function testUnwarp() public {
        address addr = address(this);
        ( ,bytes memory returndata) = agencyInstance.call{value: 0.5 ether}(
            abi.encodeWithSignature("function unwrap(address, uint256, bytes)",addr,"")
        );  
        unwarpReturn = returndata;
    }
}