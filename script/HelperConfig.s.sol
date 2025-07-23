//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Script } from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";
import {ERC20Mock} from "../test/mocks/MockERC20.sol";

abstract contract CodeConstants {
    uint256 internal constant SEPOLIA_CHAIN_ID = 11155111;
    uint256 internal constant LOCAL_CHAIN_ID = 31337;
    uint256 internal constant ETHEREUM_MAINNET_CHAIN_ID = 1;

    address internal constant SEPOLIA_ETHUSD_PRICEFEED = 0x986b5E1e1755e3C2440e960477f25201B0a8bbD4;
    address internal constant USDC_ON_SEPOLIA = 0x65aFADD39029741B3b8f0756952C74678c9cEC93;

    uint8 internal constant DECIMALS = 8; 
    int256 internal constant INITIAL_PRICE = 2000e8;
}

contract HelperConfig is Script, CodeConstants{

    error HelperConfig__InvalidChainId();

    struct NetworkConfig {
        address priceFeed;
        address acceptedToken;
    }
    
    NetworkConfig public activeNetworkConfig;
    mapping (uint256 => NetworkConfig) public networkConfigByChainId; 

    constructor() {
        if (block.chainid == SEPOLIA_CHAIN_ID) {
            // Sepolia Testnet
            activeNetworkConfig = NetworkConfig({
                priceFeed: SEPOLIA_ETHUSD_PRICEFEED, // Sepolia ETH/USD price feed
                acceptedToken: USDC_ON_SEPOLIA // USDC on Sepolia
            });
        } else if (block.chainid == 1){
            // Ethereum Mainnet
            activeNetworkConfig = NetworkConfig({
                priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419, // Mainnet ETH/USD priceFeed address
                acceptedToken: 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48 // USDC on Mainnet
            });
        } else {
            activeNetworkConfig = getOrCreateAnvilConfig();
        }
    }

    function getNetworkByChainId(uint256 chainId) public returns (NetworkConfig memory) {
        if(networkConfigByChainId[chainId].acceptedToken != address(0) 
        && networkConfigByChainId[chainId].priceFeed != address(0)) {
            return networkConfigByChainId[chainId];
        } else if (chainId == LOCAL_CHAIN_ID){
            return getOrCreateAnvilConfig();
        } else {
            revert HelperConfig__InvalidChainId();
        }
    } 

    function getOrCreateAnvilConfig() public returns (NetworkConfig memory) {
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

    function getConfig() public returns (NetworkConfig memory){
        return getNetworkByChainId(block.chainid);
    }
}