// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'forge-std/console.sol';
import {Script} from 'forge-std/Script.sol';
import {AaveGovernanceV2, IExecutorWithTimelock} from 'aave-address-book/AaveGovernanceV2.sol';

library DeployL1Proposal {
  address internal constant CROSSCHAIN_FORWARDER_POLYGON =
    0x158a6bC04F0828318821baE797f50B0A1299d45b;

  address internal constant CROSSCHAIN_FORWARDER_OPTIMISM =
    0x5f5C02875a8e9B5A26fbd09040ABCfDeb2AA6711;

  address internal constant CROSSCHAIN_FORWARDER_ARBITRUM = address(0); // TODO: place right address

  function _deployL1Proposal(
    address l1Payload,
    address polygonPayload,
    address polygonATokensPayload,
    address optimismPayload,
    address arbitrumPayload,
    bytes32 ipfsHash
  ) internal returns (uint256 proposalId) {
    require(l1Payload != address(0), "ERROR: L1_PAYLOAD can't be address(0)");
    require(polygonPayload != address(0), "ERROR: L2_PAYLOAD can't be address(0)");
    require(polygonATokensPayload != address(0), "ERROR: L2_PAYLOAD can't be address(0)");
    require(optimismPayload != address(0), "ERROR: L2_PAYLOAD can't be address(0)");
    require(arbitrumPayload != address(0), "ERROR: L2_PAYLOAD can't be address(0)");
    require(ipfsHash != bytes32(0), "ERROR: IPFS_HASH can't be bytes32(0)");

    address[] memory targets = new address[](5);
    targets[0] = l1Payload;
    targets[1] = CROSSCHAIN_FORWARDER_POLYGON;
    targets[2] = CROSSCHAIN_FORWARDER_POLYGON;
    targets[3] = CROSSCHAIN_FORWARDER_OPTIMISM;
    targets[4] = CROSSCHAIN_FORWARDER_ARBITRUM;

    uint256[] memory values = new uint256[](5);
    values[0] = 0;
    values[1] = 0;
    values[2] = 0;
    values[3] = 0;
    values[4] = 0;

    string[] memory signatures = new string[](5);
    signatures[0] = 'execute()';
    signatures[1] = 'execute(address)';
    signatures[2] = 'execute(address)';
    signatures[3] = 'execute(address)';
    signatures[4] = 'execute(address)';

    bytes[] memory calldatas = new bytes[](5);
    calldatas[0] = '';
    calldatas[1] = abi.encode(polygonPayload);
    calldatas[2] = abi.encode(polygonATokensPayload);
    calldatas[3] = abi.encode(optimismPayload);
    calldatas[4] = abi.encode(arbitrumPayload);

    bool[] memory withDelegatecalls = new bool[](5);
    withDelegatecalls[0] = true;
    withDelegatecalls[1] = true;
    withDelegatecalls[2] = true;
    withDelegatecalls[3] = true;
    withDelegatecalls[4] = true;

    return
      AaveGovernanceV2.GOV.create(
        IExecutorWithTimelock(AaveGovernanceV2.SHORT_EXECUTOR),
        targets,
        values,
        signatures,
        calldatas,
        withDelegatecalls,
        ipfsHash
      );
  }
}

// TODO: enter correct addresses
contract ProposalDeployment is Script {
  function run() external {
    vm.startBroadcast();
    DeployL1Proposal._deployL1Proposal(
      address(0), // l1 payload
      address(0), // polygonPayload
      address(0), // polygonATokensPayload
      address(0), // optimismPayload
      address(0), // arbitrumPayload
      bytes32(0)
    );
    vm.stopBroadcast();
  }
}
