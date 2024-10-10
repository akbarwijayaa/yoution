// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import "openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";
import "./reclaim/Reclaim.sol";
import "./reclaim/Addresses.sol";

contract Yoution is ERC721URIStorage, Ownable {
    mapping(bytes32 => bool) private registeredContext;

    event LogVerified(bool result);
    event Minted(address indexed owner, uint256 indexed tokenId, string tokenURI);

    constructor() ERC721("Youtube Ownership Proof", "YOP") Ownable(msg.sender) {}

    function mintAccount(Reclaim.Proof memory proof, string memory tokenURI) public {
        bytes32 hashTokenId = keccak256(abi.encodePacked(proof.claimInfo.context));
        require(!registeredContext[hashTokenId], "Account already proofed before!");

        uint256 tokenId = uint256(hashTokenId);
        _mint(msg.sender, tokenId);
        _setTokenURI(tokenId, tokenURI);
        registeredContext[hashTokenId] = true;

        emit Minted(msg.sender, tokenId, tokenURI);
    }

    function getOwner() internal pure returns (address) {
        address ownerContract = 0xAd0938fC6F5e07BCFE96db95f787B0B02497D3bf;
        return ownerContract;
    }
}