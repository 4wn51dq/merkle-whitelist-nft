//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Script } from "forge-std/Script.sol";
import { ApproveWhitelistMember } from "../src/Whitelist.sol";
import { SwapAndMint } from "../src/TokenRedemption.sol";
import { HelperConfig } from "./HelperConfig.s.sol";

contract Deploy is Script {

    function run() external returns (ApproveWhitelistMember, SwapAndMint, bytes32) {
        
        vm.deal(payable(msg.sender), 10 ether); // Give the deployer some ether to pay for gas

        // run the JS generator script to produce updated merkle.json
        string[] memory genInputs = new string[](2); // generated inputs
        genInputs[0] = "node";
        genInputs[1] = "utils/generateMerkleRoot.js";

        vm.ffi(genInputs); // runs the script 

        // read the root from merkle.json
        string [] memory getInputs = new string[](2); // inputs for reading the root
        getInputs[0] = "node";
        getInputs[1] = "utils/helperGetMerkleRoot.js";

        bytes memory output = vm.ffi(getInputs);

        // decode the hex string from the output into bytes32
        bytes32 merkleRoot;
        assembly {
            merkleRoot := mload(add(output, 32))
        }

        HelperConfig helperConfig = new HelperConfig();
        (address priceFeed, address acceptedToken) = helperConfig.activeNetworkConfig();

        vm.startBroadcast();

        ApproveWhitelistMember approval = new ApproveWhitelistMember(merkleRoot);
        SwapAndMint swapAndMint = new SwapAndMint(
            priceFeed,
            acceptedToken
        );
        merkleRoot;

        vm.stopBroadcast();

        return (approval, swapAndMint, bytes32(output));
    }
}
