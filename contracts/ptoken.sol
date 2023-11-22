// SPDX-License-Identifier: Apache-2.0 
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "./statusNFT.sol";

contract ptoken is Ownable, ERC20Burnable {
    uint256 constant tokenAmountOneDay = 10000;
    constructor(
        string memory name, 
        string memory symbol
    ) Ownable(msg.sender) ERC20(name, symbol) {

    }
    /**
     * 先要判断领币的是不是nft所有者
     * 领币
     */
    function ClaimToken(address statusNFTAddr) external {
        uint256 person = statusNFT(statusNFTAddr).getCurrentId();
        uint256 amountForOne = tokenAmountOneDay/person;
        _mint(msg.sender,amountForOne); 
    }
}