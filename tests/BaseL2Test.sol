// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from 'forge-std/Test.sol';
import {Ownable} from 'solidity-utils/contracts/oz-common/Ownable.sol';
import {AaveGovernanceV2} from 'aave-address-book/AaveGovernanceV2.sol';
import {AaveV2Ethereum} from 'aave-address-book/AaveV2Ethereum.sol';
import {ProxyHelpers} from 'aave-helpers/ProxyHelpers.sol';
import {ICollector} from '../src/interfaces/ICollector.sol';
import {IInitializableAdminUpgradeabilityProxy} from '../src/interfaces/IInitializableAdminUpgradeabilityProxy.sol';
import {UpgradeAaveCollectorPayloadL2} from '../src/contracts/payloads/UpgradeAaveCollectorPayloadL2.sol';
import {Collector} from '../src/contracts/Collector.sol';
import {MockExecutor} from './MockExecutor.sol';

abstract contract BaseL2Test is Test {
  UpgradeAaveCollectorPayloadL2 public payload;
  address internal _collector;
  address internal _newFundsAdmin;

  MockExecutor internal _executor;

  function _setUp(
    address collector,
    address newFundsAdmin,
    address aclAdmin
  ) public {
    _collector = collector;
    _newFundsAdmin = newFundsAdmin;

    payload = new UpgradeAaveCollectorPayloadL2(collector, newFundsAdmin);
    MockExecutor mockExecutor = new MockExecutor();
    vm.etch(aclAdmin, address(mockExecutor).code);

    _executor = MockExecutor(aclAdmin);
  }

  function testExecuteAdminAndFundsAdminChanged() public {
    address implBefore = ProxyHelpers.getInitializableAdminUpgradeabilityProxyImplementation(
      vm,
      _collector
    );

    // Act
    _executor.execute(address(payload));

    // Assert
    address implAfter = ProxyHelpers.getInitializableAdminUpgradeabilityProxyImplementation(
      vm,
      _collector
    );

    // implementation should change
    assertTrue(implBefore != implAfter);

    // check fundsAdmin = short executor
    ICollector collector = ICollector(_collector);
    assertEq(collector.getFundsAdmin(), _newFundsAdmin);

    // check that funds admin is not the proxy admin
    vm.expectRevert();
    vm.prank(_newFundsAdmin);

    IInitializableAdminUpgradeabilityProxy(_collector).admin();
  }
}
