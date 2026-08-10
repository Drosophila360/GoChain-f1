// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 1e18; // 1 ETH
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() public {
        // Setup code for your tests
        //fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE); // Give the USER 10 ETH
    }

    function testMinimumUsd() public view {
        // Test the minimum USD requirement
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwner() public view {
        // Test the owner of the contract
        assertEq(fundMe.i_owner(), msg.sender);
    }

    function testFund() public {
        // Test the fund function
        uint256 initialBalance = address(fundMe).balance;
        fundMe.fund{value: SEND_VALUE}(); // Fund with 1 ETH
        assertEq(address(fundMe).balance, initialBalance + SEND_VALUE);
    }

    function testFundFailsWithoutEnoughEth() public {
        // Test funding without enough ETH
        vm.expectRevert();
        fundMe.fund(); // Fund with 0.1 ETH (less than minimum)
    }

    function testFundUpdatesFundedDataStructure() public {
        // Test that funding updates the data structure
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}(); // Fund with 1 ETH
        assertEq(fundMe.getAddressToAmountFunded(address(USER)), SEND_VALUE);
    }

    function testAddsFunderToArrayOfFunders() public {
        // Test that funding adds the funder to the array
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}(); // Fund with 1 ETH
        assertEq(fundMe.getFunder(0), USER);
    }

    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}(); // Fund with 1 ETH
        _;
    }

    function testOnlyOwnerCanWithdraw() public funded {
        // Test that only the owner can withdraw

        vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithdrawWithSingleFunder() public funded {
        // Test withdrawing with a single funder
        uint256 initialOwnerBalance = fundMe.getOwner().balance;
        uint256 initialContractBalance = address(fundMe).balance;

        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        //assert
        uint256 finalOwnerBalance = fundMe.getOwner().balance;
        uint256 finalContractBalance = address(fundMe).balance;
        assertEq(finalContractBalance, 0);
        assertEq(finalOwnerBalance, initialOwnerBalance + initialContractBalance);
    }

    function testWithdrawFromMultipleFunders() public funded {
        // Test withdrawing from multiple funders
        uint160 numberOfFunders = 10;
        uint160 startingIndex = 1; // Start from 1 to avoid the owner

        for (uint160 i = startingIndex; i <= numberOfFunders; i++) {
            // vm.prank(address(i));
            hoax(address(i), SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();
        }

        uint256 initialOwnerBalance = fundMe.getOwner().balance;
        uint256 initialContractBalance = address(fundMe).balance;

        uint256 gasStart = gasleft();

        vm.txGasPrice(GAS_PRICE); // Set gas price for testing
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        uint256 gasEnd = gasleft();
        uint256 gasUsed = (gasStart - gasEnd) * GAS_PRICE;
        console.log("Gas used for withdraw with multiple funders:", gasUsed);

        //assert
        uint256 finalOwnerBalance = fundMe.getOwner().balance;
        uint256 finalContractBalance = address(fundMe).balance;
        assertEq(finalContractBalance, 0);
        assertEq(finalOwnerBalance, initialOwnerBalance + initialContractBalance);
    }

    function testCheaperWithdrawFromMultipleFunders() public funded {
        // Test cheaper withdrawing from multiple funders
        uint160 numberOfFunders = 10;
        uint160 startingIndex = 1; // Start from 1 to avoid the owner

        for (uint160 i = startingIndex; i <= numberOfFunders; i++) {
            hoax(address(i), SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();
        }

        uint256 initialOwnerBalance = fundMe.getOwner().balance;
        uint256 initialContractBalance = address(fundMe).balance;

        uint256 gasStart = gasleft();

        vm.txGasPrice(GAS_PRICE); // Set gas price for testing
        vm.prank(fundMe.getOwner());
        fundMe.cheaperWithdraw();

        uint256 gasEnd = gasleft();
        uint256 gasUsed = (gasStart - gasEnd) * GAS_PRICE;
        console.log("Gas used for cheaper withdraw with multiple funders:", gasUsed);

        //assert
        uint256 finalOwnerBalance = fundMe.getOwner().balance;
        uint256 finalContractBalance = address(fundMe).balance;
        assertEq(finalContractBalance, 0);
        assertEq(finalOwnerBalance, initialOwnerBalance + initialContractBalance);
    }
}
