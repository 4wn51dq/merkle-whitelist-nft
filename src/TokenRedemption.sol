//SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {AggregatorV3Interface} from "../lib/chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {IERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; 
import {ApproveWhitelistMember} from "./Whitelist.sol";

contract ApprovedSwap {

    AggregatorV3Interface public constant priceFeed = AggregatorV3Interface(0x986b5E1e1755e3C2440e960477f25201B0a8bbD4);
    IERC20 public constant acceptedToken = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
    // this above is the contract address
    event Swapped(address indexed user, uint tokenIn, uint ethOut);

    address public owner;

    constructor() {
        owner = msg.sender;
        // this allows the contract to call functions from approving contract.
    }
    modifier onlyWhitelisted() {
        require(ApproveWhitelistMember(owner).hasAccess(msg.sender), "Not approved");
        // use the contract address to typecast owner address so owner behaves like the contract
        // onlyWhitelisted captures the concept of onlyOwner!
        _;
    }

    function swap(uint256 tokenAmount) external onlyWhitelisted {
        require (tokenAmount>0);

        acceptedToken.transferFrom(msg.sender, address(this), tokenAmount);

        (, int price,,,) = priceFeed.latestRoundData();

        uint256 ethAmount;
        ethAmount = (tokenAmount*1e10)/(uint256(price));

        require(address(this).balance >= ethAmount);
        payable(msg.sender).transfer(ethAmount);

        emit Swapped(msg.sender, tokenAmount, ethAmount);
    }

    receive() external payable {}
    fallback() external payable {}
}