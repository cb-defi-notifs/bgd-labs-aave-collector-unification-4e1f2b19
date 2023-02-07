// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from 'forge-std/Test.sol';
import {AaveV2Ethereum, AaveGovernanceV2, AaveV3Polygon, AaveV3Avalanche, AaveV3Optimism, AaveV3Arbitrum, AaveV3Fantom, AaveV3Harmony} from 'aave-address-book/AaveAddressBook.sol';
import {AaveGovernanceV2} from 'aave-address-book/AaveGovernanceV2.sol';
import {IInitializableAdminUpgradeabilityProxy} from '../src/interfaces/IInitializableAdminUpgradeabilityProxy.sol';
import {MockExecutor} from './MockExecutor.sol';
import {BaseTest} from './BaseTest.sol';

// TODO: test mainnet - stream id not changed
contract ProposalTestMainnet is BaseTest {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('ethereum'), 15882200);
    _setUp(
      AaveV2Ethereum.COLLECTOR,
      AaveGovernanceV2.SHORT_EXECUTOR,
      0,
      AaveGovernanceV2.SHORT_EXECUTOR
    );
  }
}

contract ProposalTestPolygon is BaseTest {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('polygon'), 39006430);
    _setUp(
      AaveV3Polygon.COLLECTOR,
      AaveGovernanceV2.POLYGON_BRIDGE_EXECUTOR,
      100000,
      AaveV3Polygon.ACL_ADMIN
    );
  }
}

contract ProposalTestAvalanche is BaseTest {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('avalanche'), 25937220);
    _setUp(
      AaveV3Avalanche.COLLECTOR,
      address(0xa35b76E4935449E33C56aB24b23fcd3246f13470), // Avalanche v3 Guardian
      100000,
      AaveV3Avalanche.ACL_ADMIN
    );
  }
}

contract ProposalTestOptimism is BaseTest {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('optimism'), 72720040);
    _setUp(
      AaveV3Optimism.COLLECTOR,
      AaveGovernanceV2.OPTIMISM_BRIDGE_EXECUTOR,
      100000,
      AaveV3Optimism.ACL_ADMIN
    );
  }
}

contract ProposalTestArbitrum is BaseTest {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('arbitrum'));
    _setUp(
      AaveV3Arbitrum.COLLECTOR,
      AaveGovernanceV2.ARBITRUM_BRIDGE_EXECUTOR,
      100000,
      AaveV3Arbitrum.ACL_ADMIN
    );
  }
}

contract ProposalTestFantom is BaseTest {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('fantom'), 55246290);
    _setUp(
      AaveV3Fantom.COLLECTOR,
      address(0xf71fc92e2949ccF6A5Fd369a0b402ba80Bc61E02), // Guardian
      100000,
      AaveV3Fantom.ACL_ADMIN
    );
  }
}

// contract ProposalTestHarmony is BaseTest {
//   function setUp() public {
//     vm.createSelectFork(vm.rpcUrl('harmony'), 33354598);
//     _setUp(
//       AaveV3Harmony.COLLECTOR,
//       AaveV3Harmony.DEFAULT_INCENTIVES_CONTROLLER,
//       AaveV3Harmony.ACL_ADMIN
//     );
//   }
// }
