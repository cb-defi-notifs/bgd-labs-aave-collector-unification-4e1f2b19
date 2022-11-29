// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from 'forge-std/Test.sol';
import {AaveV2Polygon, AaveV3Polygon, AaveV2Avalanche, AaveV3Avalanche} from 'aave-address-book/AaveAddressBook.sol';
import {ProxyHelpers} from 'aave-helpers/ProxyHelpers.sol';
import {IInitializableAdminUpgradeabilityProxy} from '../src/interfaces/IInitializableAdminUpgradeabilityProxy.sol';
import {IAaveIncentivesController} from '../src/interfaces/v2/IAaveIncentivesController.sol';
import {MockExecutor} from './MockExecutor.sol';
import {BaseATokensTest} from './BaseATokensTest.sol';

contract ProposalTestPolygon is BaseATokensTest {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('polygon'), 34550201);
    _setUp(
      AaveV2Polygon.POOL,
      IAaveIncentivesController(0x357D51124f59836DeD84c8a1730D72B749d8BC23),
      address(AaveV2Polygon.POOL_CONFIGURATOR),
      AaveV2Polygon.COLLECTOR,
      AaveV3Polygon.COLLECTOR,
      AaveV3Polygon.ACL_ADMIN
    );
  }
}

contract ProposalTestAvalanche is BaseATokensTest {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('avalanche'), 21815137);
    _setUp(
      AaveV2Avalanche.POOL,
      IAaveIncentivesController(0x01D83Fe6A10D2f2B7AF17034343746188272cAc9),
      address(AaveV2Avalanche.POOL_CONFIGURATOR),
      AaveV2Avalanche.COLLECTOR,
      AaveV3Avalanche.COLLECTOR,
      address(0x01244E7842254e3FD229CD263472076B1439D1Cd) // Avalanche v2 Guardian
    );
  }
}
