// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from 'forge-std/Test.sol';
import {AaveV2Ethereum, AaveV3Polygon, AaveV3Avalanche, AaveV3Optimism, AaveV3Arbitrum, AaveV3Fantom, AaveV3Harmony} from 'aave-address-book/AaveAddressBook.sol';
import {AaveGovernanceV2} from 'aave-address-book/AaveGovernanceV2.sol';
import {ProxyHelpers} from 'aave-helpers/ProxyHelpers.sol';
import {IInitializableAdminUpgradeabilityProxy} from '../src/interfaces/IInitializableAdminUpgradeabilityProxy.sol';
import {MockExecutor} from './MockExecutor.sol';
import {BaseTest} from './BaseTest.sol';

// TODO: test mainnet - stream id not changed
contract ProposalTestMainnet is BaseTest {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('ethereum'), 15882200);
    _setUp(
      AaveV2Ethereum.COLLECTOR,
      address(0x7d9103572bE58FfE99dc390E8246f02dcAe6f611),
      100000,
      AaveGovernanceV2.SHORT_EXECUTOR
    );
  }
}

contract ProposalTestOptimism is BaseTest {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('optimism'), 33162240);
    _setUp(
      AaveV3Optimism.COLLECTOR,
      address(0x7d9103572bE58FfE99dc390E8246f02dcAe6f611),
      100000,
      AaveV3Optimism.ACL_ADMIN
    );
  }
}

contract ProposalTestArbitrum is BaseTest {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('arbitrum'), 34229000);
    _setUp(
      AaveV3Arbitrum.COLLECTOR,
      address(0x7d9103572bE58FfE99dc390E8246f02dcAe6f611),
      100000,
      AaveV3Arbitrum.ACL_ADMIN
    );
  }
}

contract ProposalTestFantom is BaseTest {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('fantom'), 50315029);
    _setUp(
      AaveV3Fantom.COLLECTOR,
      address(0xf71fc92e2949ccF6A5Fd369a0b402ba80Bc61E02),
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
