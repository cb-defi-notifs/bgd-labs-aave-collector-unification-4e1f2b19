// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import 'forge-std/Test.sol';
import 'forge-std/console.sol';
import {Script} from 'forge-std/Script.sol';

import {AaveV2Ethereum, AaveV3Polygon, AaveV3Avalanche, AaveV3Optimism, AaveV3Arbitrum, AaveV3Fantom, AaveV3Harmony, AaveGovernanceV2} from 'aave-address-book/AaveAddressBook.sol';
import {AaveGovernanceV2} from 'aave-address-book/AaveGovernanceV2.sol';
import {UpgradeAaveCollectorPayload} from '../src/contracts/payloads/UpgradeAaveCollectorPayload.sol';
import {UpgradeCollectorAndATokens} from '../src/contracts/payloads/UpgradeCollectorAndATokens.sol';

// artifacts
string constant upgradeV2TokensAvalancheArtifact = 'out/UpgradeV2ATokensAvalanche.sol/UpgradeV2ATokensAvalanche.json';
string constant upgradeV2TokensPolygonArtifact = 'out/UpgradeV2ATokensPolygon.sol/UpgradeV2ATokensPolygon.json';

contract DeployMainnet is Script {
  function run() external {
    vm.startBroadcast();
    new UpgradeAaveCollectorPayload(AaveV2Ethereum.COLLECTOR, AaveGovernanceV2.SHORT_EXECUTOR, 0);
    vm.stopBroadcast();
  }
}

contract DeployPolygon is Test {
  function run() external {
    vm.startBroadcast();
    UpgradeAaveCollectorPayload collectorPayload = new UpgradeAaveCollectorPayload(
      AaveV3Polygon.COLLECTOR,
      address(0xdc9A35B16DB4e126cFeDC41322b3a36454B1F772), // Bridge executor
      100000
    );

    address upgradeV2TokensImpl = deployCode(upgradeV2TokensPolygonArtifact);
    console.log('upgradeV2TokensPolygonImpl:', upgradeV2TokensImpl);

    new UpgradeCollectorAndATokens(address(collectorPayload), upgradeV2TokensImpl);
    vm.stopBroadcast();
  }
}

// TODO: currently Avalanche v2 Pool Admin is 0x01244E7842254e3FD229CD263472076B1439D1Cd
// need to be changed to the actual guardian
contract DeployAvalanche is Test {
  function run() external {
    vm.startBroadcast();
    UpgradeAaveCollectorPayload collectorPayload = new UpgradeAaveCollectorPayload(
      AaveV3Avalanche.COLLECTOR,
      address(0xa35b76E4935449E33C56aB24b23fcd3246f13470), // Guardian
      100000
    );

    address upgradeV2TokensImpl = deployCode(upgradeV2TokensAvalancheArtifact);
    console.log('upgradeV2TokensAvalancheImpl:', upgradeV2TokensImpl);

    new UpgradeCollectorAndATokens(address(collectorPayload), upgradeV2TokensImpl);
    vm.stopBroadcast();
  }
}

contract DeployOptimism is Script {
  function run() external {
    vm.startBroadcast();
    new UpgradeAaveCollectorPayload(
      AaveV3Optimism.COLLECTOR,
      address(0x7d9103572bE58FfE99dc390E8246f02dcAe6f611), // Bridge Executor
      100000
    );
    vm.stopBroadcast();
  }
}

contract DeployArbitrum is Script {
  function run() external {
    vm.startBroadcast();
    new UpgradeAaveCollectorPayload(
      AaveV3Arbitrum.COLLECTOR,
      address(0x7d9103572bE58FfE99dc390E8246f02dcAe6f611), // Bridge Executor
      100000
    );
    vm.stopBroadcast();
  }
}

contract DeployFantom is Script {
  function run() external {
    vm.startBroadcast();
    new UpgradeAaveCollectorPayload(
      AaveV3Fantom.COLLECTOR,
      address(0xf71fc92e2949ccF6A5Fd369a0b402ba80Bc61E02), // Guardian
      100000
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
