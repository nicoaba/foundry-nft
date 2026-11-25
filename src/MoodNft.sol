// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNft is ERC721 {
    uint256 private s_tokenCounter;
    string private s_happySvgImageUri;
    string private s_sadSvgImageUri;

    enum Mood {
        HAPPY,
        SAD
    }

    mapping(uint256 => Mood) private s_tokenIdToMood;

    constructor(string memory happySvgImageUri, string memory sadSvgImageUri) ERC721("Emoji", "EJI") {
        s_tokenCounter = 0;
        s_happySvgImageUri = happySvgImageUri;
        s_sadSvgImageUri = sadSvgImageUri;
    }

    function mintNft() public {
        uint256 tokenId = s_tokenCounter;
        s_tokenCounter++;
        s_tokenIdToMood[tokenId] = Mood.HAPPY;
        _safeMint(msg.sender, tokenId);
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        _requireOwned(tokenId);
        string memory imageURI;
        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            imageURI = s_happySvgImageUri;
        } else {
            imageURI = s_sadSvgImageUri;
        }

        string memory json = string.concat(
            '{"name":"',
            name(),
            '", ',
            '"description":"An NFT that reflects the owner\'s mood.", ',
            '"image":"',
            imageURI,
            '"}'
        );

        return string.concat("data:application/json;base64,", Base64.encode(bytes(json)));
    }
}
