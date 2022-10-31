// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from 'forge-std/Test.sol';
import {Ownable} from 'solidity-utils/contracts/oz-common/Ownable.sol';
import {AaveGovernanceV2} from 'aave-address-book/AaveGovernanceV2.sol';
import {AaveV2Ethereum} from 'aave-address-book/AaveV2Ethereum.sol';
import {ProxyHelpers} from 'aave-helpers/ProxyHelpers.sol';
import {ICollector} from '../src/interfaces/ICollector.sol';
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

  function testExecuteAdminAndFundsAdminChanged() public {
    address implBefore = ProxyHelpers.getInitializableAdminUpgradeabilityProxyImplementation(
      vm,
      AaveV2Ethereum.COLLECTOR
    );
    ICollector collector = ICollector(AaveV2Ethereum.COLLECTOR);
    uint256 streamId = collector.getNextStreamId();

    // Act
    _executor.execute(address(payload));

    // Assert
    address implAfter = ProxyHelpers.getInitializableAdminUpgradeabilityProxyImplementation(
      vm,
      AaveV2Ethereum.COLLECTOR
    );

    // implementation should change
    assertTrue(implBefore != implAfter);

    // check fundsAdmin = short executor
    assertEq(collector.getFundsAdmin(), AaveGovernanceV2.SHORT_EXECUTOR);

    // check that streamId remained the same
    assertEq(collector.getNextStreamId(), streamId);
    // we can't check that admin of the proxy is updated, because only the admin can call the admin() method
    // and we do not know the address of the ProxyAdmin contract here
  }
}
