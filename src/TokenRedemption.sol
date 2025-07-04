//SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {AggregatorV3Interface} from "../lib/chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {ERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; 
import {ApproveWhitelistMember} from "./Whitelist.sol";
import {ERC721, ERC721URIStorage} from "../lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721URIStorage.sol"; 


contract SwapAndMint is ERC721URIStorage {
    // this contract allows whitelisted members to swap USDC(if not on local chain) for ETH and mint NFTs

    AggregatorV3Interface private s_priceFeed;
    ERC20 private s_acceptedToken;
    
    event Swapped(address indexed user, uint tokenIn, uint ethOut);
    event NFTMinted(address indexed user, uint tokenId, string tokenURI);

    // ApproveWhitelistMember public approveWhitelistMember = ApproveWhitelistMember();

    address public immutable owner; // = approveWhitelistMember.getOwner();

    constructor(address priceFeed, address acceptedToken) ERC721("MembersNFT", "WHITNFT") {
        owner = msg.sender;
        tokenID= 0;
        s_priceFeed = AggregatorV3Interface(priceFeed);
        s_acceptedToken = ERC20(acceptedToken);
    }
    
    modifier onlyWhitelisted() {
        require(ApproveWhitelistMember(owner).hasAccess(msg.sender), "Not approved");
        // use the contract address to typecast owner address so owner behaves like the contract
        // onlyWhitelisted captures the concept of onlyOwner!
        _;
    }

    uint256 public MAX_NFT_MINT_COST;

    function swap(uint256 tokenAmount) external onlyWhitelisted returns (uint256) {
        require(address(s_acceptedToken) != address(0), "Accepted token not set");
        require(address(s_priceFeed) != address(0), "Price feed not set");
        require (tokenAmount>0);

        s_acceptedToken.transferFrom(msg.sender, address(this), tokenAmount);
        // transfer the token from the user to this contract
        // this function 

        (, int eth_usdPriceFeed,,,) = s_priceFeed.latestRoundData();

        uint256 ethAmount;
        ethAmount = (tokenAmount*1e10)/(uint256(eth_usdPriceFeed));

        require(address(this).balance >= ethAmount);
        payable(msg.sender).transfer(ethAmount);

        MAX_NFT_MINT_COST = ethAmount;

        emit Swapped(msg.sender, tokenAmount, ethAmount);
        return MAX_NFT_MINT_COST;
        // this returns the amount of ETH user can use to mint NFTs in NFTMint.sol
    }

    uint256 public tokenID;

    mapping (address => bool) public hasMinted;

    function mintNFT(string memory tokenURI) external payable{
        require(ApproveWhitelistMember(owner).hasAccess(msg.sender), "only members can mint NFT");
        require(!hasMinted[msg.sender], "only 1 NFT per member");
        require(msg.value == MAX_NFT_MINT_COST, "can create nft only with the amount of ETH swapped");
        //nftminting contract deployer can use the approvewhitelistmember contract

        _safeMint(msg.sender, tokenID);
        _setTokenURI(tokenID, tokenURI); // sets tokenURI to token URI of tokenID
        tokenID++;

        hasMinted[msg.sender] = true;

        emit NFTMinted(msg.sender, tokenID, tokenURI);
    }

    receive() external payable {}
    fallback() external payable {}
    // this function is called when the contract receives a transaction that does not match any function signature
}

// once a function executes return, it immediately exits and does not execute any further statements in that function.