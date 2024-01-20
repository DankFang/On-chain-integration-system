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
    address public statusNFTAddr;
    mapping(address => uint256) public lastClaimTime;
    mapping (address=>bool) isMerchant;
    mapping(address=>uint) burnedPtoken;
    
    modifier onlyMerchant() {
        bool _isMerchant = isMerchant[msg.sender];
        require(_isMerchant, "You are not merchant");
        _;
    }
    event burnPtoen(address indexed operator,uint indexed amount);
    constructor(
        string memory name, 
        string memory symbol,
        address _statusNFTAddr
    ) Ownable(msg.sender) ERC20(name, symbol) {
        startTime = block.timestamp;
        statusNFTAddr = _statusNFTAddr;
    }
    
    /**
     * 先要判断领币的是不是nft所有者
     * 领币
     */
    function claimToken(uint256 tokenId) external nonReentrant{
        uint256 person = statusNFT(statusNFTAddr).getCurrentId();
        address owner = statusNFT(statusNFTAddr).ownerOf(tokenId);
        require(msg.sender == owner,"You are not in this community");
        require(block.timestamp >= lastClaimTime[msg.sender] + claimCooldown, "You can only claim once per day");
        uint256 amountForOne = tokenAmountOneDay/person;
        _mint(msg.sender,amountForOne);
        lastClaimTime[msg.sender] = block.timestamp;
    }

    function burnToken(uint burnAmount) external onlyMerchant {
        ERC20Burnable.burn(burnAmount);
        burnedPtoken[msg.sender]+=burnAmount;
        emit burnPtoen(_msgSender(),burnAmount);
    }
}