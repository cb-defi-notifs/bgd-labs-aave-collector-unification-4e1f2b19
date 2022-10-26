// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IPayload} from '../../interfaces/IPayload.sol';

contract PayloadUpgradeCollectorAndATokens {
  IPayload public immutable UPGRADE_COLLECTOR_PAYLOAD;
  IPayload public immutable UPGRADE_V2_ATOKENS_PAYLOAD;

  constructor(address upgradeCollectorPayload, address upgradeV2ATokensPayload) {
    UPGRADE_COLLECTOR_PAYLOAD = IPayload(upgradeCollectorPayload);
    UPGRADE_V2_ATOKENS_PAYLOAD = IPayload(upgradeV2ATokensPayload);
  }

  function execute() external {
    UPGRADE_COLLECTOR_PAYLOAD.execute();
    UPGRADE_V2_ATOKENS_PAYLOAD.execute();
  }
}
