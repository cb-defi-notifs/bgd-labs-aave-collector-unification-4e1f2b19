// SPDX-License-Identifier: MIT
pragma experimental ABIEncoderV2;
pragma solidity >=0.6.0;

import {ConfiguratorInputTypes} from 'aave-address-book/AaveV2.sol';

interface ILendingPoolConfiguratorV2 {
  function updateAToken(ConfiguratorInputTypes.UpdateATokenInput calldata input) external;
}
