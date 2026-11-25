// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {MoodNft} from "../src/MoodNft.sol";
import {Test} from "forge-std/Test.sol";
import {DeployMoodNft} from "../script/DeployMoodNft.s.sol";

contract TestMoodNft is Test {
    DeployMoodNft public deployer;
    MoodNft public moodNft;
    address public USER = makeAddr("user");
    address public ATTACKER = makeAddr("attacker");

    function setUp() public {
        deployer = new DeployMoodNft();
        moodNft = deployer.run();
    }

    function testMintStartsHappy() public {
        vm.prank(USER);
        moodNft.mintNft();
        assert(moodNft.getMood(0) == MoodNft.Mood.HAPPY);
    }

    function testOwnerCanFlipMood() public {
        vm.startPrank(USER);
        moodNft.mintNft();
        moodNft.flipMood(0);
        vm.stopPrank();
        assert(moodNft.getMood(0) == MoodNft.Mood.SAD);
    }

    function testNonOwnerCannotFlipMood() public {
        vm.prank(USER);
        moodNft.mintNft();
        vm.expectRevert(MoodNft.MoodNft__CantFlipMoodIfNotOwner.selector);
        vm.prank(ATTACKER);
        moodNft.flipMood(0);
    }
}
