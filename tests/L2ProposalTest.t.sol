// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from 'forge-std/Test.sol';
import {AaveV3Polygon, AaveV3Avalanche, AaveV3Optimism, AaveV3Arbitrum, AaveV3Fantom, AaveV3Harmony} from 'aave-address-book/AaveAddressBook.sol';
import {ProxyHelpers} from 'aave-helpers/ProxyHelpers.sol';
import {IInitializableAdminUpgradeabilityProxy} from '../src/interfaces/IInitializableAdminUpgradeabilityProxy.sol';
import {MockExecutor} from './MockExecutor.sol';
import {BaseL2Test} from './BaseL2Test.sol';

// contract ProposalTestPolygon is BaseTest {
//   function setUp() public {
//     vm.createSelectFork(vm.rpcUrl('polygon'), 34550201);
//     _setUp(
//       AaveV3Polygon.POOL_ADDRESSES_PROVIDER,
//       AaveV3Polygon.DEFAULT_INCENTIVES_CONTROLLER,
//       AaveV3Polygon.ACL_ADMIN
//     );
//   }
// }

// contract ProposalTestAvalanche is BaseTest {
//   address constant A_USDC = 0x625E7708f30cA75bfd92586e17077590C60eb4cD;

//   function setUp() public {
//     vm.createSelectFork(vm.rpcUrl('avalanche'), 21309814);
//     _setUp(
//       AaveV3Avalanche.POOL_ADDRESSES_PROVIDER,
//       AaveV3Avalanche.DEFAULT_INCENTIVES_CONTROLLER,
//       AaveV3Avalanche.ACL_ADMIN
//     );
//   }

contract ProposalTestOptimism is BaseL2Test {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('optimism'), 33162240);
    _setUp(
      AaveV3Optimism.COLLECTOR,
      address(0x7d9103572bE58FfE99dc390E8246f02dcAe6f611),
      AaveV3Optimism.ACL_ADMIN
    );
  }
}

contract ProposalTestArbitrum is BaseL2Test {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('arbitrum'), 34229000);
    _setUp(
      AaveV3Arbitrum.COLLECTOR,
      address(0x7d9103572bE58FfE99dc390E8246f02dcAe6f611),
      AaveV3Arbitrum.ACL_ADMIN
    );
  }
}

contract ProposalTestFantom is BaseL2Test {
  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('fantom'), 50315029);
    _setUp(
      AaveV3Fantom.COLLECTOR,
      address(0xf71fc92e2949ccF6A5Fd369a0b402ba80Bc61E02),
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
