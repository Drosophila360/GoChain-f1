// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

uint256 constant SEND_VALUE = 1e18; // 1 ETH    

contract FundFundMe is Script {
    
    function FundFundMeIntegration(address mostRecentDeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentDeployed)).fund{value: SEND_VALUE}();
        vm.stopBroadcast();
        console.log("Funded FundMe contract with 1 ETH", SEND_VALUE);
    }

    function run() external {
        address mostRecentDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        FundFundMeIntegration(mostRecentDeployed);
    }
    
}
contract WithdrawFundMe is Script {

    function WithdrawFundMeIntegration(address mostRecentDeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentDeployed)).withdraw();
        vm.stopBroadcast();
        console.log("Withdrawn from FundMe contract");
    }

    function run() external {
        address mostRecentDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        WithdrawFundMeIntegration(mostRecentDeployed);
    }

}