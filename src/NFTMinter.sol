//SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {ERC721, ERC721URIStorage} from "../lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721URIStorage.sol"; 
import {ApproveWhitelistMember} from "./Whitelist.sol";


contract MintNFT is ERC721URIStorage{
    // now a user will mint NFT using their merkle proof

    address public immutable owner;
    uint256 public tokenID;

    constructor() ERC721("MembersNFT", "WHITNFT") {
        owner = msg.sender;
        tokenID= 0;
    }

    function mintNFT(string memory tokenURI) external {
        require(ApproveWhitelistMember(owner).hasAccess(msg.sender), "only members can mint NFT");
        //nftminting contract deployer can use the approvewhitelistmember contract

        _safeMint(msg.sender, tokenID);
        _setTokenURI(tokenID, tokenURI); // sets tokenURI to token URI of tokenID
        tokenID++;
    }
}