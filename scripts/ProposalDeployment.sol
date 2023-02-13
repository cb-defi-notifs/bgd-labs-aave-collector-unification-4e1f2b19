// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'forge-std/console.sol';
import {Script} from 'forge-std/Script.sol';
import {GovHelpers} from 'aave-helpers/GovHelpers.sol';

contract ProposalDeployment is Script {
  function run() external {
    GovHelpers.Payload[] memory payloads = new GovHelpers.Payload[](5);
    payloads[0] = GovHelpers.buildMainnet(
      address(0) // deployed mainnet payload
    );
    payloads[1] = GovHelpers.buildPolygon(
      address(0) // deployed polygon payload
    );
    payloads[2] = GovHelpers.buildPolygon(
      address(0) // deployed polygon aTokens payload
    );
    payloads[3] = GovHelpers.buildArbitrum(
      address(0) // deployed arbitrum payload
    );
    payloads[4] = GovHelpers.buildOptimism(
      address(0) // deployed optimism payload
    );

    vm.startBroadcast();

    GovHelpers.createProposal(
      payloads,
      bytes32(0) // TODO: replace with proper ipfs hash
    );

    vm.stopBroadcast();
  }
}
