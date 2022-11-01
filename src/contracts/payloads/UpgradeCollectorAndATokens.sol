// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Address} from 'solidity-utils/contracts/oz-common/Address.sol';

import {IProposalGenericExecutor} from '../../interfaces/IProposalGenericExecutor.sol';

contract UpgradeCollectorAndATokens {
  address public immutable UPGRADE_COLLECTOR_PAYLOAD;
  address public immutable UPGRADE_V2_ATOKENS_PAYLOAD;

  constructor(address upgradeCollectorPayload, address upgradeV2ATokensPayload) {
    UPGRADE_COLLECTOR_PAYLOAD = upgradeCollectorPayload;
    UPGRADE_V2_ATOKENS_PAYLOAD = upgradeV2ATokensPayload;
  }

  function execute() external {
    Address.functionDelegateCall(
      UPGRADE_COLLECTOR_PAYLOAD,
      abi.encode(IProposalGenericExecutor.execute.selector)
    );
    Address.functionDelegateCall(
      UPGRADE_V2_ATOKENS_PAYLOAD,
      abi.encode(IProposalGenericExecutor.execute.selector)
    );
  }
}
