// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";
import {Reclaim} from "./reclaim/Reclaim.sol";
import {Claims} from "./reclaim/Claims.sol";
import {Addresses} from "./reclaim/Addresses.sol";

contract Yoution is ERC721URIStorage, Ownable {
    address public reclaimAddress;
    address public constant ownerAddress = 0xAd0938fC6F5e07BCFE96db95f787B0B02497D3bf;

    constructor() ERC721("Youtube Ownership Proof", "YOP") Ownable(msg.sender) {
        reclaimAddress = Addresses.BASE_SEPOLIA;
    }

    function mintAccount(Reclaim.Proof memory proof, string memory tokenURI) public {
        Reclaim(reclaimAddress).verifyProof(proof);

        require(proof.signedClaim.claim.owner == ownerAddress, "Owner is not valid!");

        string memory videoId = Claims.extractFieldFromContext(proof.claimInfo.context, '"channelId":"');
        uint256 tokenId = uint256(keccak256(abi.encodePacked(videoId)));

        require(_ownerOf(tokenId) == address(0), "Account already minted!");

        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, tokenURI);
    }
}
