//SPDX-License-Identifier
pragma solidity ^0.8.20;

import {Test,console} from "../lib/forge-std/src/Test.sol";
import {DeployContract} from "../script/Deploy.s.sol";
import {SwapAndMint} from "../src/TokenRedemption.sol";
import {ApproveWhitelistMember} from "../src/Whitelist.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";

contract ContractsTest is Test {

    SwapAndMint public swapAndMint;
    ApproveWhitelistMember public memberApprover;
    HelperConfig public helperConfig;

    address private priceFeed;
    address private acceptedToken;
    bytes32 private rootHash;

    function setUp() public {
        DeployContract deployer = new DeployContract();
        (memberApprover, swapAndMint,) = deployer.run();

        HelperConfig.NetworkConfig memory config = helperConfig.getConfig();
        priceFeed = config.priceFeed;
        acceptedToken = config.acceptedToken;

        // rootHash = 
    }


}