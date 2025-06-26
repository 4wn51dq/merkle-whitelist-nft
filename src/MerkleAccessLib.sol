//SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {MerkleProof} from "../lib/openzeppelin-contracts/contracts/utils/cryptography/MerkleProof.sol";

library MerkleAccessLib {

    function addressToLeaf(address prover) internal pure returns (bytes32) {
       return keccak256(abi.encodePacked(prover));
    }

    function verifyProof(bytes32[] calldata proof, bytes32 rootHash, address prover) internal pure returns (bool) {
        //startTime = block.timestamp;
        // this above is wrong since everytime the function is called startime is reset.

        bytes32 leaf = addressToLeaf(prover);
        return MerkleProof.verify(proof, rootHash, leaf);
    }
}