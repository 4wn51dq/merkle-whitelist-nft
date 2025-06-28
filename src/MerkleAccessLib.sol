//SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {MerkleProof} from "../lib/openzeppelin-contracts/contracts/utils/cryptography/MerkleProof.sol";

library MerkleAccessLib {


    // compute the leaf node for any address
    function addressToLeaf(address prover) internal pure returns (bytes32) {
       return keccak256(abi.encodePacked(prover));
    }

    function verifyProof(bytes32[] calldata proof, bytes32 rootHash, address prover) internal pure returns (bool) {
        
        bytes32 leaf = addressToLeaf(prover);
        return MerkleProof.verify(proof, rootHash, leaf);
    }
    // this function uses the MerkleProof library to verify the proof
    // the merkle proof library does this on chain!! 
    // the verify() function in the MerkleProof library uses processProof() function in it to do the computations
    // these computations are done on-chain directly on the evm
    // this means gas is spent on the verification process
} 