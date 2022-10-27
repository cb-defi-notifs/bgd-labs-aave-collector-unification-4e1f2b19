// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IProposalGenericExecutor} from '../../interfaces/IProposalGenericExecutor.sol';

contract UpgradeCollectorAndATokens {
  IProposalGenericExecutor public immutable UPGRADE_COLLECTOR_PAYLOAD;
  IProposalGenericExecutor public immutable UPGRADE_V2_ATOKENS_PAYLOAD;

  constructor(address upgradeCollectorPayload, address upgradeV2ATokensPayload) {
    UPGRADE_COLLECTOR_PAYLOAD = IProposalGenericExecutor(upgradeCollectorPayload);
    UPGRADE_V2_ATOKENS_PAYLOAD = IProposalGenericExecutor(upgradeV2ATokensPayload);
  }

  function execute() external {
    UPGRADE_COLLECTOR_PAYLOAD.execute();
    UPGRADE_V2_ATOKENS_PAYLOAD.execute();
  }
}
