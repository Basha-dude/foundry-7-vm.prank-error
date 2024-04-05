// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {MockV3Aggregator} from "../test/Mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    uint8 internal constant DECIMALS = 8;
    int256 internal constant INTIALSUPPLY = 2000e10;

    struct NetworkConfig {
        address priceFeed;
    }

    NetworkConfig public activeNetworkConfig;

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = GetSepoliaEthConfig();
        } else if (block.chainid == 1) {
            activeNetworkConfig = GetEthereumEthConfig();
        } else {
            activeNetworkConfig = GetAnvilEthConfig();
        }
    }

    function GetSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory SepoiliaPriceFeed = NetworkConfig(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return SepoiliaPriceFeed;
    }

    function GetEthereumEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory EthereumPriceFeed = NetworkConfig(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);
        return EthereumPriceFeed;
    }

    function GetAnvilEthConfig() public returns (NetworkConfig memory) {
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }
        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS, INTIALSUPPLY);
        vm.stopBroadcast();
        NetworkConfig memory mock = NetworkConfig(address(mockPriceFeed));
        return mock;
    }
}
