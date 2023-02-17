// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import {Script} from 'forge-std/Script.sol';

import {AaveV2Ethereum, AaveV2Avalanche, AaveV2Polygon, AaveV3Polygon, AaveV3Avalanche, AaveV3Optimism, AaveV3Arbitrum, AaveV3Fantom, AaveV3Harmony, AaveGovernanceV2, AaveGovernanceV2, AaveMisc} from 'aave-address-book/AaveAddressBook.sol';
import {UpgradeAaveCollectorPayload} from '../src/contracts/payloads/UpgradeAaveCollectorPayload.sol';

// artifacts
string constant upgradeV2TokensArtifact = 'out/MigrateV2CollectorPayload.sol/MigrateV2CollectorPayload.json';

uint256 constant DEFAULT_STREAM_ID = 100000;

contract DeployMainnet is Script {
  function run() external {
    vm.startBroadcast();
    new UpgradeAaveCollectorPayload(
      AaveV2Ethereum.COLLECTOR,
      AaveMisc.PROXY_ADMIN_ETHEREUM,
      AaveGovernanceV2.SHORT_EXECUTOR,
      0
    );
    vm.stopBroadcast();
  }
}

contract DeployPolygon is Script {
  function run() external {
    vm.startBroadcast();
    new UpgradeAaveCollectorPayload(
      AaveV3Polygon.COLLECTOR,
      AaveMisc.PROXY_ADMIN_POLYGON,
      AaveGovernanceV2.POLYGON_BRIDGE_EXECUTOR,
      DEFAULT_STREAM_ID
    );

    vm.stopBroadcast();
  }
}

contract DeployAvalanche is Script {
  function run() external {
    vm.startBroadcast();
    new UpgradeAaveCollectorPayload(
      AaveV3Avalanche.COLLECTOR,
      AaveMisc.PROXY_ADMIN_AVALANCHE,
      address(0xa35b76E4935449E33C56aB24b23fcd3246f13470), // Avalanche v3 Guardian
      DEFAULT_STREAM_ID
    );

    vm.stopBroadcast();
  }
}

contract DeployOptimism is Script {
  function run() external {
    vm.startBroadcast();
    new UpgradeAaveCollectorPayload(
      AaveV3Optimism.COLLECTOR,
      AaveMisc.PROXY_ADMIN_OPTIMISM,
      AaveGovernanceV2.OPTIMISM_BRIDGE_EXECUTOR,
      DEFAULT_STREAM_ID
    );
    vm.stopBroadcast();
  }
}

contract DeployArbitrum is Script {
  function run() external {
    vm.startBroadcast();
    new UpgradeAaveCollectorPayload(
      AaveV3Arbitrum.COLLECTOR,
      AaveMisc.PROXY_ADMIN_ARBITRUM,
      AaveGovernanceV2.ARBITRUM_BRIDGE_EXECUTOR,
      DEFAULT_STREAM_ID
    );
    vm.stopBroadcast();
  }
}

contract DeployFantom is Script {
  function run() external {
    vm.startBroadcast();
    new UpgradeAaveCollectorPayload(
      AaveV3Fantom.COLLECTOR,
      AaveMisc.PROXY_ADMIN_FANTOM,
      address(0xf71fc92e2949ccF6A5Fd369a0b402ba80Bc61E02), // Guardian
      DEFAULT_STREAM_ID
    );
    vm.stopBroadcast();
  }
}

// contract DeployHarmony is Script {
//   function run() external {
//     vm.startBroadcast();
//     new UpgradeAaveCollectorPayload(
//       AaveV3Harmony.COLLECTOR,
//       address(0) // Guardian
//     );
//     vm.stopBroadcast();
//   }
// }
