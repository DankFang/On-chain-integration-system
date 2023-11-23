// SPDX-License-Identifier: Apache-2.0 
/**
 * @author DankFang
 * 
 * creatTime: 2023-11-21
 */
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "./statusNFT.sol";

contract ptoken is Ownable, ERC20Burnable, ReentrancyGuard {
    uint256 constant tokenAmountOneDay = 10000;
    uint256 public startTime;
    uint256 public claimCooldown = 1 days; // 设置领取冷却时间为1天
    uint256 public ptokenPrice;

    mapping(address => uint256) public lastClaimTime;
    mapping (address=>bool) isMerchant;
    
    modifier onlyMerchant() {
        bool _isMerchant = isMerchant[msg.sender];
        require(_isMerchant, "You are not merchant");
        _;
    }

    constructor(
        string memory name, 
        string memory symbol
    ) Ownable(msg.sender) ERC20(name, symbol) {
        startTime = block.timestamp;
    }
    /**
     * 先要判断领币的是不是nft所有者
     * 领币
     */
    function claimToken(address statusNFTAddr,uint256 tokenId) external nonReentrant{
        uint256 person = statusNFT(statusNFTAddr).getCurrentId();
        address owner = statusNFT(statusNFTAddr).ownerOf(tokenId);
        require(msg.sender == owner,"You are not in this community");
        require(block.timestamp >= lastClaimTime[msg.sender] + claimCooldown, "You can only claim once per day");
        uint256 amountForOne = tokenAmountOneDay/person;
        _mint(msg.sender,amountForOne);
        lastClaimTime[msg.sender] = block.timestamp;
    }
    // 商家付钱购买ptoken来销毁，3%进入指定地址（手续费）其余的全部注入uniswap池子
    // 此处得采用chainlink的喂价机制
    // 
    function burnToken() external payable onlyMerchant {

    }

    function getPtokenPrice() public view returns (uint256) {
        return ptokenPrice;
    }

    function setPtokenPrice() public {

    }

}