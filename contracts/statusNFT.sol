// SPDX-License-Identifier: Apache-2.0 
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract statusNFT is ERC721, Ownable, ReentrancyGuard{

    bytes32 public root;
    uint256 private tokenID;
    mapping (address=>bool) isMinted;
    event rootChanged(
        bytes32 indexed oldroot,
        bytes32 indexed newroot
    );

    constructor(bytes32 _root) Ownable(msg.sender) ERC721("SNFT","SNFT"){
        root = _root;
        emit rootChanged(root, _root);
    }

    // 通过默克尔树验证过后再让mint
    function mintStatus(bytes32[] memory proof, bytes32 leaf) public nonReentrant { 
        // bool canMint = _verifystatus(proof, leaf);
        address to = msg.sender; 
        bool canMint = MerkleProof.verify(proof, root, leaf);
        bool alreadyMint = isMinted[to]; 
        require(canMint, "You are not in this community!");
        require(!alreadyMint, "You are already minted!"); 
        _increTokenId();
        uint256 tokenId = getCurrentId(); 
        isMinted[to] = true;  
        _safeMint(to, tokenId);
    }

    function changeRoot(bytes32 _root) external onlyOwner{
        root = _root;
        emit rootChanged(root, _root);
    }

    function _increTokenId() internal {
        tokenID += 1;
    }

    function getCurrentId() public view returns (uint256) {
        return tokenID; 
    }
}