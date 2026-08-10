// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/interactions.s.sol";

contract FundMeTestIntergration is Test {
    FundMe fundMe;
    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 1e18; // 1 ETH
    uint256 constant STARTING_BALANCE = 10e18; // 10 ETH
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE); // Give the USER 10 ETH
    }

    function testUserCanFundAndWithdrawIntegration() public {

    // 2. Fund the contract using the integration script
    FundFundMe fundFundMe = new FundFundMe();
    vm.deal(address(fundFundMe), STARTING_BALANCE); // Give the FundFundMe contract 10 ETH
    fundFundMe.FundFundMeIntegration(address(fundMe));

    // 3. Withdraw using the integration script
    WithdrawFundMe withdrawFundMe = new WithdrawFundMe(); 
    withdrawFundMe.WithdrawFundMeIntegration(address(fundMe));

    // 4. verify that the contract balance is 0 after withdrawal
    assert(address(fundMe).balance == 0);
}

}