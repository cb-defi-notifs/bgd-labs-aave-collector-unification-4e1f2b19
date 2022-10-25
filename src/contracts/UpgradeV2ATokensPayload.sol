// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;

import {AToken} from '@aave/core-v2/contracts/protocol/tokenization/AToken.sol';

contract UpgradeV2ATokensPayload {
  AToken aToken = new AToken();
  // init it with some mock stuff
  // get all aTokens on the market
  // re-init tokens using configurator

  // send everything to v3 ?
}
