// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getPrice(AggregatorV3Interface priceFeed) internal view returns (uint256) {
        (uint80 roundId, int256 price,, uint256 updatedAt, uint80 answeredInRound) = priceFeed.latestRoundData();

        // 1. Prevent negative/zero price conversion (fixes unsafe-typecast)
        require(price > 0, "PriceConverter: Invalid price");

        // 2. Prevent stale or incomplete price feed updates
        require(updatedAt != 0, "PriceConverter: Round incomplete");
        require(answeredInRound >= roundId, "PriceConverter: Stale price");

        // 3. Safe to cast now because price is guaranteed > 0
        // Standard ETH/USD feed has 8 decimals; multiplying by 1e10 scales it to 18 decimals (wei standard)
        return uint256(price) * 1e10;
    }

    // call it get fiatConversionRate, since it assumes something about decimals
    // It wouldn't work for every aggregator
    function getConversionRate(uint256 ethAmount, AggregatorV3Interface priceFeed) internal view returns (uint256) {
        uint256 ethPrice = getPrice(priceFeed);
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        // the actual ETH/USD conversation rate, after adjusting the extra 0s.
        return ethAmountInUsd;
    }
}
