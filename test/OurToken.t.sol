//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "forge-std/Test.sol";
import {OurToken} from "../src/OurToken.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";

contract OurTokenTest is Test {
    OurToken public ourToken;
    DeployOurToken public deployer;
    address bob = address(0xB0B);
    address alice = address(0xA11ce);
    uint256 public constant STARTING_SUPPLY = 1 ether;
    function setUp() public {
       deployer = new DeployOurToken();
       ourToken = deployer.run();
       vm.prank(msg.sender);
       ourToken.transfer(bob, STARTING_SUPPLY);
    }

    function testBobBalace() public view {
        assertEq(ourToken.balanceOf(bob), STARTING_SUPPLY);
    }

    function testAllowancesWorks() public {
       uint256 intialAllowance = 1000;
       //Bob approves Alice to spend  tokens on her behalf
        vm.prank(bob);
        ourToken.approve(alice, intialAllowance);
        vm.prank(alice);
        uint256 transferAmount = 500;
        ourToken.transferFrom(bob, alice, transferAmount);
        assertEq(ourToken.balanceOf(bob), STARTING_SUPPLY - transferAmount);
        assertEq(ourToken.balanceOf(alice), transferAmount);
    }

     function testTransfer() public {
        uint256 transferAmount = 100;
        vm.prank(bob);
        bool success = ourToken.transfer(alice, transferAmount);
        
        assertTrue(success);
        assertEq(ourToken.balanceOf(bob), STARTING_SUPPLY - transferAmount);
        assertEq(ourToken.balanceOf(alice), transferAmount);
    }

}