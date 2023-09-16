// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

import "@chainlink/contracts/src/v0.8/interfaces/FlagsInterface.sol";

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract firstArbitrum {
    /*Price Feed Address For Arbitrum Georli DAI/USD:0x103b53E977DA6E4Fa92f76369c8b7e20E7fb7fe1

     */

    AggregatorV3Interface private constant priceFeed =
        AggregatorV3Interface(0x103b53E977DA6E4Fa92f76369c8b7e20E7fb7fe1);

    address private constant FLAG_ARBITRUM_SEQ_OFFLINE =
        address(
            bytes20(
                bytes32(
                    uint256(keccak256("chainlink.flags.arbitrum-seq-offline")) -
                        1
                )
            )
        );

    FlagsInterface internal chainlinkFlags;

    constructor() {
        chainlinkFlags = FlagsInterface(
            0x491B1dDA0A8fa069bbC1125133A975BF4e85a91b
        );
    }

    function getThePrice() public view returns (int) {
        bool isRaised = chainlinkFlags.getFlag(FLAG_ARBITRUM_SEQ_OFFLINE);
        if (isRaised) {
            // If flag is raised we shouldn't perform any critical operations
            revert("Chainlink feeds are not being updated");
        }

        (
            uint80 roundID,
            int price,
            uint startedAt,
            uint updatedAt,
            uint80 answeredInRound
        ) = priceFeed.latestRoundData();

        return price;
    }
}
