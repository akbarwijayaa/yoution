// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./reclaim/Reclaim.sol";
import "./reclaim/Addresses.sol";

contract Yoution is ERC721URIStorage, Ownable {
    uint256 private tokenId = 1;
    bool public _hasMinted;
    address public reclaimAddress;
    address private ownerContract = 0xAd0938fC6F5e07BCFE96db95f787B0B02497D3bf;

    event LogVerified(bool result);
    event Minted(address indexed owner, uint256 indexed tokenId, string tokenURI);

    constructor() ERC721("Youtube Ownership Proof", "YOP") Ownable(msg.sender) {
        reclaimAddress = Addresses.BASE_SEPOLIA_TESTNET; 
    }

    function mint(Reclaim.Proof memory proof, string memory tokenURI) public {
        require(!_hasMinted, "Minting can only be done once");
        Reclaim(reclaimAddress).verifyProof(proof);
        require(proof.signedClaim.claim.owner == ownerContract, "Owner not trusted!");
        _mint(msg.sender, tokenId);
        _setTokenURI(tokenId, tokenURI);

        emit Minted(msg.sender, tokenId, tokenURI);
    }
}