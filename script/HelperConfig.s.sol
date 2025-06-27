//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Script } from "forge-std/Script.sol";
import { ApproveWhitelistMember } from "../src/Whitelist.sol";
// import { ApprovedSwap } from "../src/TokenRedemption.sol"; 
// import { AggregatorV3Interface } from "../lib/chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
// import { IERC20 } from "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
// import { MerkleProof } from "../lib/openzeppelin-contracts/contracts/utils/cryptography/MerkleProof.sol";
// import { MerkleAccessLib } from "../src/MerkleAccessLib.sol";

contract HelperConfig is Script {

    struct NetworkConfig {
        address priceFeed;
        address acceptedToken;
        address whitelistContract;
    }
    
    NetworkConfig public activeNetworkConfig;

    constructor() {
        if (block.chainid == 11155111) {
            // Sepolia Testnet
            activeNetworkConfig = NetworkConfig({
                priceFeed: 0x986b5E1e1755e3C2440e960477f25201B0a8bbD4, // Sepolia ETH/USD price feed
                acceptedToken: 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, // USDC on Sepolia
                whitelistContract: address(ApproveWhitelistMember) // Replace with actual whitelist contract address
            });
        } else {
            activeNetworkConfig = getOrCreateAnvilConfig();
        }
    }

    function getOrCreateAnvilConfig() internal returns (NetworkConfig memory) {
        if( activeNetworkConfig.priceFeed != address(0) ) {
            return activeNetworkConfig;
        }

        vm.startBroadcast();

        vm.stopBroadcast();

    }
}