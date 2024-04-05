// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundme;

    address USER = makeAddr("user");
      
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundme = deployFundMe.run();
            vm.deal(USER, STARTING_BALANCE);  
              }

    function testOwner() public view {
        console.log("ADDRESS of fundme ", address(fundme));
        console.log("msg.sender ", msg.sender);
        assertEq(fundme.i_owner(), msg.sender);
    }

    function testMinimumUsdIsFive() public view {
        assertEq(fundme.MINIMUM_USD(), 5e18);
        console.log("msg.sender of testMinimumUsdIsFive ", msg.sender);
    }

    function testFund() public payable {
        // fundme.fund{value: 10000000000000000}();
        // address[]  memory funder = fundme.funders;
        // assertEq(funder[0],msg.sender);
    }

    function testPriceFeedversionisAccurate() public view {
        uint256 version = fundme.getVersion();
        assertEq(version, 4);
    }

    function testFundFailsWithoutEth() public {
        vm.expectRevert();
        fundme.fund();
    }

     function testFundUpatesFundedDataStructure()  public {
        vm.prank(USER);
        fundme.fund{value: SEND_VALUE}();
        uint256 amountFunded = fundme.getAddressToAmountFunded(USER);
        assertEq(amountFunded,SEND_VALUE);
     }
   
}
