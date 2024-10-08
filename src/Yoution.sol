// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./reclaim/Reclaim.sol";
import "./reclaim/Addresses.sol";

contract Yoution is ERC721URIStorage, Ownable {
    address public reclaimAddress;
    address private ownerContract = 0xAd0938fC6F5e07BCFE96db95f787B0B02497D3bf;

    mapping(bytes32 => bool) private registeredContext;

    event LogVerified(bool result);
    event Minted(address indexed owner, uint256 indexed tokenId, string tokenURI);

    constructor() ERC721("Youtube Ownership Proof", "YOP") Ownable(msg.sender) {
        reclaimAddress = Addresses.BASE_SEPOLIA_TESTNET; 
    }

    function mintAccount(Reclaim.Proof memory proof, string memory tokenURI) public {
        // Reclaim(reclaimAddress).verifyProof(proof);

        require(proof.signedClaim.signatures.length > 0, "No valid signature!");
        bytes32 hashed = Claims.hashClaimInfo(proof.claimInfo);
		require(proof.signedClaim.claim.identifier == hashed);
        require(proof.signedClaim.claim.owner == ownerContract, "Owner not trusted!");
        require(bytes(proof.claimInfo.context).length > 0, "Context cannot empty!");
        
        bytes32 hashTokenId = keccak256(abi.encodePacked(proof.claimInfo.context));
        require(!registeredContext[hashTokenId], "Context already exist!");

        uint256 tokenId = uint256(hashTokenId);
        _mint(msg.sender, tokenId);
        _setTokenURI(tokenId, tokenURI);
        registeredContext[hashTokenId] = true;

        emit Minted(msg.sender, tokenId, tokenURI);
    }
}