// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import "openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";
import "./reclaim/Reclaim.sol";
import "./reclaim/Claims.sol";

contract Yoution is ERC721URIStorage, Ownable {
    address public constant reclaimAddress = 0x8CDc031d5B7F148ab0435028B16c682c469CEfC3;
    string public constant providersHash = "0xf44817617d1dfa5219f6aaa0d4901f9b9b7a6845bbf7b639d9bffeacc934ff9a";
    address public constant ownerAddress = 0xAd0938fC6F5e07BCFE96db95f787B0B02497D3bf;

    constructor() ERC721("Youtube Ownership Proof", "YOP") Ownable(msg.sender) {}

    function mintAccount(Reclaim.Proof memory proof, string memory tokenURI) public {
        Reclaim(reclaimAddress).verifyProof(proof);

        string memory submittedProviderHash =
            Claims.extractFieldFromContext(proof.claimInfo.context, '"providerHash":"');
        
        require(
            proof.signedClaim.claim.owner == ownerAddress,
            "Owner is not valid!"
        );

        require(
            keccak256(abi.encodePacked(submittedProviderHash)) == keccak256(abi.encodePacked(providersHash)),
            "Provider hash is not valid!"
        );
        
        string memory videoId = Claims.extractFieldFromContext(proof.claimInfo.context, '"channelId":"');
        uint256 tokenId = uint256(keccak256(abi.encodePacked(videoId)));

        require(_ownerOf(tokenId) == address(0), "Account already minted!");
        
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, tokenURI);

    }

}