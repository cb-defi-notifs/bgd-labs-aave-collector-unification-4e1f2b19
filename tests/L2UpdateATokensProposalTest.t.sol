// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from 'forge-std/Test.sol';
import {AaveV2Polygon, AaveV3Polygon, AaveV3Avalanche} from 'aave-address-book/AaveAddressBook.sol';
import {ProxyHelpers} from 'aave-helpers/ProxyHelpers.sol';
import {IInitializableAdminUpgradeabilityProxy} from '../src/interfaces/IInitializableAdminUpgradeabilityProxy.sol';
import {MockExecutor} from './MockExecutor.sol';
import {BaseUpgradeCollectorAndATokens} from './BaseUpgradeCollectorAndATokens.sol';

string constant upgradeV2TokensAvalancheArtifact = 'out/UpgradeV2ATokensAvalanche.sol/UpgradeV2ATokensAvalanche.json';
string constant upgradeV2TokensPolygonArtifact = 'out/UpgradeV2ATokensPolygon.sol/UpgradeV2ATokensPolygon.json';

contract ProposalTestPolygon is BaseUpgradeCollectorAndATokens {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('polygon'), 34550201);
    _setUp(
      AaveV2Polygon.POOL,
      AaveV2Polygon.COLLECTOR,
      AaveV3Polygon.COLLECTOR,
      address(0xdc9A35B16DB4e126cFeDC41322b3a36454B1F772),
      AaveV3Polygon.ACL_ADMIN,
      upgradeV2TokensPolygonArtifact
    );
  }
}

// contract ProposalTestAvalanche is BaseUpgradeCollectorAndATokens {
//   function setUp() public {
//     vm.createSelectFork(vm.rpcUrl('avalanche'), 21815137);
//     _setUp(
//       AaveV3Avalanche.COLLECTOR,
//       address(0xa35b76E4935449E33C56aB24b23fcd3246f13470),
//       address(0xa35b76E4935449E33C56aB24b23fcd3246f13470), // Execute on behalf of the guardian
//       upgradeV2TokensAvalancheArtifact
//     );
//   }
// }
