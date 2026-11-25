// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {MoodNft} from "../src/MoodNft.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract DeployMoodNft is Script {
    function run() external returns (MoodNft) {
        string memory happySvg = vm.readFile("./img/dynamicNft/happy.svg");
        string memory sadSvg = vm.readFile("./img/dynamicNft/sad.svg");

        vm.startBroadcast();
        MoodNft moodNft = new MoodNft(svgToImageURI(happySvg), svgToImageURI(sadSvg));
        vm.stopBroadcast();

        return moodNft;
    }

    function svgToImageURI(string memory svg) public pure returns (string memory) {
        return string.concat("data:image/svg+xml;base64,", Base64.encode(bytes(svg)));
    }
}
