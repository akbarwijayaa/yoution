// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import "openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";
import "./reclaim/Reclaim.sol";
import "./reclaim/Addresses.sol";

contract Yoution is ERC721URIStorage, Ownable {
    uint256 private tokenId = 1;
    bool public _hasMinted;
    address public reclaimAddress;
    string[] public providersHashes;

    event Minted(address indexed owner, uint256 indexed tokenId, string tokenURI);

    constructor(string[] memory _providersHashes) ERC721("Youtube Ownership Proof", "YOP") Ownable(msg.sender) {
        providersHashes = _providersHashes;
        reclaimAddress = Addresses.BASE_SEPOLIA_TESTNET; 
    }

    function isVerifyProof(Reclaim.Proof memory proof) public returns (bool){
       bool verified = Reclaim(reclaimAddress).verifyProof(proof);
       return verified;
    }

    function mint(Reclaim.Proof memory proof, string memory tokenURI) public returns (uint256) {
        require(!_hasMinted, "Minting can only be done once");
        require(isVerifyProof(proof), "Invalid proof");
        
        _mint(msg.sender, tokenId);
        _setTokenURI(tokenId, tokenURI);

        emit Minted(msg.sender, tokenId, tokenURI);
    }
}