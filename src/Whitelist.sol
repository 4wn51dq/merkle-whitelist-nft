//SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

// import the openzeppelin library for finding merkle proof
import {MerkleProof} from "../lib/openzeppelin-contracts/contracts/utils/cryptography/MerkleProof.sol";
import {MerkleAccessLib} from "../src/MerkleAccessLib.sol";

contract ApproveWhitelistMember{
    
    using MerkleProofLib for bytes32[];

    address public owner;
    bytes32 private rootHash;
    uint256 public accessWindowTime;

    uint256 startTime;
    uint256 endTime;

    constructor(address _owner){
        owner = _owner;
    }

    modifier onlyOwner(){
        require (msg.sender == owner);
        _;
    }

    function setRoot(bytes32 newRoot) external onlyOwner {
        // rootHash = 0x0;
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

// because storing the entire list of addresses on chain is expensive this is the method we will use
    // by only having the root of merkle tree with whitelisted addresses as leaves

    //constructor(bytes32 _rootHash, uint256 _accessWindowTime) {
    //rootHash = _rootHash;
    //  accessWindowTime = _accessWindowTime;
    //}

    // defining a constructor means once the contract is deployed the rootHash is one fixed value??
    // define the constructor to declare owner so whitelist is flexible and rootHash can be 
    // changed by the owner. 

    // the creation of rootHash from the whitelist happens off chain 

    
    // the process proof function returns the rebuilt hash from the leaf using the proof
    // now this computed hash has to be the same as the rootHash, hence verification is done.

    // the merkle tree is defined by the root only in our contract.
    // for this a proof must be provided.. what will be the proof?
    // the proof is that the path from the leaf to the root exists.
    // the proof will contain all hashes starting from leaf to its parent to 
    // its parent and there on in a sorted array. 


