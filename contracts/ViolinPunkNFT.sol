// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract ViolinPunkNFT is ERC721, Ownable {
    using Strings for uint256;

    uint256 public constant MAX_SUPPLY = 10;

    uint256 public price = 0.01 ether;

    uint256 public tokenId = 1;

    string private _baseUri;

    constructor() ERC721("ViolinPunkNFT", "VPA") {}

    event NftMinted(address indexed minter, uint indexed tokenId);

    function tokenURI(
        uint256 _tokenId
    ) public view override returns (string memory) {
        require(_exists(_tokenId), "URI query for nonexistent token");

        string memory baseURI = _baseURI();

        return
            bytes(baseURI).length != 0
                ? string(
                    abi.encodePacked(baseURI, _tokenId.toString(), ".json")
                )
                : "";
    }

    function _baseURI() internal view override returns (string memory) {
        return _baseUri;
    }

    function mint() public payable {
        require(msg.value >= price, "Ether sent is not sufficient.");

        require(tokenId <= MAX_SUPPLY, "Sold out!");

        _safeMint(msg.sender, tokenId);

        emit NftMinted(msg.sender, tokenId);

        ++tokenId;
    }

    function setBaseURI(string memory newBaseURI) external onlyOwner {
        _baseUri = newBaseURI;
    }

    function setPrice(uint newPrice) external onlyOwner {
        price = newPrice;
    }

    function withdraw() external onlyOwner nonReentrant {
        require(payable(msg.sender).send(address(this).balance));
    }
}
