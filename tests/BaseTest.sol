// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from 'forge-std/Test.sol';
import {ProxyHelpers} from 'aave-helpers/ProxyHelpers.sol';
import {TestWithExecutor} from 'aave-helpers/GovHelpers.sol';
import {ICollector} from '../src/interfaces/ICollector.sol';
import {IInitializableAdminUpgradeabilityProxy} from '../src/interfaces/IInitializableAdminUpgradeabilityProxy.sol';
import {UpgradeAaveCollectorPayload} from '../src/contracts/payloads/UpgradeAaveCollectorPayload.sol';
import {Collector} from '../src/contracts/Collector.sol';

abstract contract BaseTest is TestWithExecutor {
  UpgradeAaveCollectorPayload public payload;
  address internal _collector;
  address internal _proxyAdmin;
  address internal _newFundsAdmin;
  uint256 internal _streamId;

  function _setUp(
    address collector,
    address proxyAdmin,
    address newFundsAdmin,
    uint256 streamId,
    address executor
  ) public {
    _collector = collector;
    _proxyAdmin = proxyAdmin;
    _newFundsAdmin = newFundsAdmin;
    _streamId = streamId;

    payload = new UpgradeAaveCollectorPayload(collector, proxyAdmin, newFundsAdmin, streamId);
    _selectPayloadExecutor(executor);
  }

  function testExecuteProxyAdminAndFundsAdminChanged() public {
    ICollector collector = ICollector(_collector);
    address implBefore = ProxyHelpers.getInitializableAdminUpgradeabilityProxyImplementation(
      vm,
      _collector
    );

    uint256 currentStreamId;
    if (_streamId == 0) {
      currentStreamId = collector.getNextStreamId();
    }

    // Act
    _executePayload(address(payload));

    // Assert
    address implAfter = ProxyHelpers.getInitializableAdminUpgradeabilityProxyImplementation(
      vm,
      _collector
    );

    // implementation should change
    assertTrue(implBefore != implAfter);

    // check fundsAdmin = short executor/guardian
    assertEq(collector.getFundsAdmin(), _newFundsAdmin);

    // check that funds admin is not the proxy admin
    vm.prank(_proxyAdmin);

    address newAdmin = IInitializableAdminUpgradeabilityProxy(_collector).admin();
    assertEq(newAdmin, _proxyAdmin);

    // check that stream id is set or not modified
    uint256 newStreamId = collector.getNextStreamId();
    if (_streamId > 0) {
      assertEq(newStreamId, _streamId);
    } else {
      assertEq(newStreamId, currentStreamId);
    }
  }
}
