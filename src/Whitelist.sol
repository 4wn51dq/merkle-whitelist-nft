//SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

// import the openzeppelin library for finding merkle proof
// import {MerkleAccessLib} from "../src/MerkleAccessLib.sol";
import {MerkleProof} from "../lib/openzeppelin-contracts/contracts/utils/cryptography/MerkleProof.sol";

// import {ERC1155} from "../lib/openzeppelin-contracts/contracts/token/ERC1155/ERC1155.sol";

contract ApproveWhitelistMember {
    
    // using MerkleAccessLib for bytes32[];

    address private immutable owner;
    bytes32 private rootHash;
    // the root hash we got from merkleRoot.json during deployment

    constructor(bytes32 _rootHash) {
        owner = msg.sender;
        rootHash = _rootHash;
    }

    modifier onlyOwner(){
        require (msg.sender == owner);
        _;
    }
    
    mapping (address => bool) public hasAccess;

    function claimAccess(bytes32[] calldata proof) public {
        require(!hasAccess[msg.sender], "already claimed");

        // require(proof.verifyProof(rootHash, msg.sender), "must be whitelisted!");
        require(MerkleProof.verify(proof, rootHash, keccak256(abi.encodePacked(msg.sender))));

        hasAccess[msg.sender] = true;
    }    

    function getOwner() external view returns (address) {
        return owner;
    }
}


