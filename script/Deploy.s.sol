//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Script } from "forge-std/Script.sol";
import { ApproveWhitelistMember } from "../src/Whitelist.sol";
import { ApprovedSwap } from "../src/TokenRedemption.sol";

contract Deploy is Script {
    function run() external returns (ApproveWhitelistMember, ApprovedSwap) {
        vm.startBroadcast();

        ApproveWhitelistMember approval = new ApproveWhitelistMember();
        ApprovedSwap swap = new ApprovedSwap();

        vm.stopBroadcast();

        return (approval, swap);
    }
}
