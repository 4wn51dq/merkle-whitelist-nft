//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Script } from "forge-std/Script.sol";
import { ApproveWhitelistMember } from "../src/Whitelist.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";
import {ERC20Mock} from "../test/mocks/MockERC20.sol";

contract HelperConfig is Script{

    struct NetworkConfig {
        address priceFeed;
        address acceptedToken;
    }

    uint8 private constant DECIMALS = 8; 
    int256 private constant INITIAL_PRICE = 2000e8;
    
    NetworkConfig public activeNetworkConfig;

    constructor() {
        if (block.chainid == 11155111) {
            // Sepolia Testnet
            activeNetworkConfig = NetworkConfig({
                priceFeed: 0x986b5E1e1755e3C2440e960477f25201B0a8bbD4, // Sepolia ETH/USD price feed
                acceptedToken: 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48 // USDC on Sepolia
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

        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(
            DECIMALS,
            INITIAL_PRICE
        ); 

        ERC20Mock mockAcceptedToken = new ERC20Mock();

        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(mockPriceFeed),
            acceptedToken: address(mockAcceptedToken)
        });

        return anvilConfig;
    }
}