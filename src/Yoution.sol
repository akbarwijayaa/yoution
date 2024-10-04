// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import "openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";

contract Yoution is ERC721URIStorage, Ownable {
    bool private _hasMinted;

    event Minted(address indexed owner, uint256 indexed tokenId, string tokenURI);

    constructor(string memory name, string memory symbol, string memory initialTokenURI) ERC721(name, symbol) Ownable(msg.sender) {
        require(!_hasMinted, "Minting has already been done");
        mint(initialTokenURI);
        _hasMinted = true;
    }

    function isValidProof(address account, bytes memory proof) internal view returns (bool) {
        // Logika untuk memvalidasi proof
        return true; // Ganti dengan logika yang sesuai
    }

    // tokenURI = "ipfs://QmaqffhK8kU9LHH56uvtYXbZKsdM2P3HCau4TWQ3iZnYpi"
    function mint(string memory tokenURI) internal returns (uint256) {
        require(!_hasMinted, "Minting can only be done once");
        require(isValidProof(account, proof), "Invalid proof");

        uint256 tokenId = uint256(uint160(msg.sender)); // Konversi address ke uint256
        require(!_exists(tokenId), "Token ID already exists");

        _mint(msg.sender, tokenId);
        _setTokenURI(tokenId, tokenURI);

        emit Minted(msg.sender, tokenId, tokenURI);
    }
}