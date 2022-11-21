// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from 'forge-std/Test.sol';
import {AaveV2Polygon, AaveV3Polygon, AaveV2Avalanche, AaveV3Avalanche} from 'aave-address-book/AaveAddressBook.sol';
import {ProxyHelpers} from 'aave-helpers/ProxyHelpers.sol';
import {IInitializableAdminUpgradeabilityProxy} from '../src/interfaces/IInitializableAdminUpgradeabilityProxy.sol';
import {MockExecutor} from './MockExecutor.sol';
import {BaseATokensTest} from './BaseATokensTest.sol';

string constant upgradeV2TokensAvalancheArtifact = 'out/UpgradeV2ATokensAvalanche.sol/UpgradeV2ATokensAvalanche.json';
string constant upgradeV2TokensPolygonArtifact = 'out/UpgradeV2ATokensPolygon.sol/UpgradeV2ATokensPolygon.json';

contract ProposalTestPolygon is BaseATokensTest {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('polygon'), 34550201);
    _setUp(
      AaveV2Polygon.POOL,
      AaveV2Polygon.COLLECTOR,
      AaveV3Polygon.COLLECTOR,
      AaveV3Polygon.ACL_ADMIN,
      upgradeV2TokensPolygonArtifact
    );
  }
}

contract ProposalTestAvalanche is BaseATokensTest {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('avalanche'), 21815137);
    _setUp(
      AaveV2Avalanche.POOL,
      AaveV3Avalanche.COLLECTOR,
      AaveV3Avalanche.COLLECTOR,
      address(0x01244E7842254e3FD229CD263472076B1439D1Cd),
      upgradeV2TokensAvalancheArtifact
    );
  }
}
