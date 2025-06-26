//SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

// import the openzeppelin library for finding merkle proof
import {MerkleProof} from "../lib/openzeppelin-contracts/contracts/utils/cryptography/MerkleProof.sol";
import {MerkleAccessLib} from "../src/MerkleAccessLib.sol";
// import {ERC1155} from "../lib/openzeppelin-contracts/contracts/token/ERC1155/ERC1155.sol";

contract ApproveWhitelistMember {
    
    using MerkleAccessLib for bytes32[];

    address public owner;
    bytes32 private rootHash;
    uint256 public accessWindowTime;

    uint256 startTime;
    uint256 endTime;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner(){
        require (msg.sender == owner);
        _;
    }

    function setRoot(bytes32 newRoot) external onlyOwner {
        rootHash = newRoot;
    }

    function createAccessWindow(uint256 accessDuration) external onlyOwner {
        startTime = block.timestamp;
        endTime = startTime + accessDuration;
    }
    
    mapping (address => bool) public hasAccess;

    function claimAccess(bytes32[] calldata proof) public {
        require(!hasAccess[msg.sender], "already claimed");
        require(proof.verifyProof(rootHash, msg.sender), "must be whitelisted!");

        require (block.timestamp >= startTime && block.timestamp <= endTime);

        hasAccess[msg.sender] = true;
    }    
}


