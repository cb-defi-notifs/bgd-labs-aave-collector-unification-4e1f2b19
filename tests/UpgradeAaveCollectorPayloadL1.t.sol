// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from 'forge-std/Test.sol';
import {AaveGovernanceV2} from 'aave-address-book/AaveGovernanceV2.sol';
// import {ProxyHelpers} from 'aave-helpers/ProxyHelpers.sol';
import {IInitializableAdminUpgradeabilityProxy} from '../src/interfaces/IInitializableAdminUpgradeabilityProxy.sol';
import {UpgradeAaveCollectorPayloadL1} from '../src/contracts/payloads/UpgradeAaveCollectorPayloadL1.sol';
import {Collector} from '../src/contracts/Collector.sol';
import {MockExecutor} from './MockExecutor.sol';

contract UpgradeAaveCollectorPayloadL1Test is Test {
  UpgradeAaveCollectorPayloadL1 public payload;
  MockExecutor internal _executor;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('ethereum'));

    payload = new UpgradeAaveCollectorPayloadL1();
    MockExecutor mockExecutor = new MockExecutor();
    vm.etch(AaveGovernanceV2.SHORT_EXECUTOR, address(mockExecutor).code);

    _executor = MockExecutor(AaveGovernanceV2.SHORT_EXECUTOR);
  }

  function test_ExecuteAdminAndFundsAdminChanged() public {
    // get collector impl
    // get stream id

    // Act
    _executor.execute(address(payload));

    // check admin
    // check
  }
}
