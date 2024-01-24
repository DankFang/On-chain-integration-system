// SPDX-License-Identifier: Apache-2.0 
/**
 * @author DankFang
 * 
 * creatTime: 2023-11-21
 */
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract ptoken is Ownable, ERC20Burnable, ReentrancyGuard {
    uint256 constant tokenAmountOneDay = 10000;
    uint256  public personAmount;
    // uint256 public startTime;
    uint256 public claimCooldown = 1 days; // 设置领取冷却时间为1天
    // uint256 public ptokenPrice;
    bytes32 public root;
    // address public statusNFTAddr;
    mapping(address => uint256) public lastClaimTime;
    mapping (address=>bool) isMerchant;
    mapping(address=>uint) burnedPtoken;
    modifier onlyMerchant() {
        bool _isMerchant = isMerchant[msg.sender];
        require(_isMerchant, "You are not merchant");
        _;
    }
    event burnPtoen(address indexed operator,uint indexed amount);
    event rootChanged(
    bytes32 indexed oldroot,
    bytes32 indexed newroot
    );
    event personAmountChanged(
    uint256 newPersonAmount
    );
    constructor(
        bytes32 _root,
        uint256 _personAmount,
        string memory name, 
        string memory symbol
    ) Ownable(msg.sender) ERC20(name, symbol) {
        // startTime = block.timestamp;
        root = _root;
        personAmount = _personAmount;
        emit personAmountChanged(_personAmount);
        emit rootChanged(root, _root);
    }
    
    function claimToken(bytes32[] memory proof) external nonReentrant{
        bytes32 leaf = keccak256(abi.encodePacked((msg.sender)));
        bool canClaim = MerkleProof.verify(proof, root, leaf);
        require(canClaim, "You are not in this community!");
        require(block.timestamp >= lastClaimTime[msg.sender] + claimCooldown, "You can only claim once per day");
        
        uint256 amountForOne = tokenAmountOneDay/personAmount;
        _mint(msg.sender,amountForOne);
        lastClaimTime[msg.sender] = block.timestamp;
    }

    function burnToken(uint burnAmount) external onlyMerchant {
        ERC20Burnable.burn(burnAmount);
        burnedPtoken[msg.sender]+=burnAmount;
        emit burnPtoen(_msgSender(),burnAmount);
    }

    function changeRoot(bytes32 _root) external onlyOwner{
        root = _root;
        emit rootChanged(root, _root);
    }

    function changePersonAmount(uint256 newPersonAmount) external onlyOwner{
        personAmount = newPersonAmount;
        emit personAmountChanged(newPersonAmount);
    }
}