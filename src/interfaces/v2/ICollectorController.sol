// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;

import {IERC20V2} from './IERC20V2.sol';

interface ICollectorController {
  function transfer(
    address collector,
    IERC20V2 token,
    address recipient,
    uint256 amount
  ) external;
}
