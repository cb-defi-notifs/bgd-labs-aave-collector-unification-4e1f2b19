// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'forge-std/console.sol';
import {Script} from 'forge-std/Script.sol';
import {AaveGovernanceV2, IExecutorWithTimelock} from 'aave-address-book/AaveGovernanceV2.sol';

struct PayloadData {
  address target;
  uint256 value;
  string signature;
  bytes calldatas;
  bool withDelegateCall;
}

address constant CROSSCHAIN_FORWARDER_ARBITRUM = address(0); // TODO: place right address

library DeployL1Proposal {
  function _deployL1Proposal(PayloadData[] memory payloadData, bytes32 ipfsHash)
    internal
    returns (uint256 proposalId)
  {
    require(ipfsHash != bytes32(0), "ERROR: IPFS_HASH can't be bytes32(0)");

    address[] memory targets = new address[](payloadData.length);
    uint256[] memory values = new uint256[](payloadData.length);
    string[] memory signatures = new string[](payloadData.length);
    bytes[] memory calldatas = new bytes[](payloadData.length);
    bool[] memory withDelegateCalls = new bool[](payloadData.length);

    for (uint256 i; i < payloadData.length; ++i) {
      require(payloadData[i].target != address(0), "ERROR: PAYLOAD can't be address(0)");

      targets[i] = payloadData[i].target;
      values[i] = payloadData[i].value;
      signatures[i] = payloadData[i].signature;
      calldatas[i] = payloadData[i].calldatas;
      withDelegateCalls[i] = payloadData[i].withDelegateCall;
    }

    return
      AaveGovernanceV2.GOV.create(
        IExecutorWithTimelock(AaveGovernanceV2.SHORT_EXECUTOR),
        targets,
        values,
        signatures,
        calldatas,
        withDelegateCalls,
        ipfsHash
      );
  }
}

// TODO: enter correct addresses
contract ProposalDeployment is Script {
  function run() external {
    vm.startBroadcast();

    PayloadData[] memory payloadData = new PayloadData[](5);

    payloadData[0] = PayloadData({
      target: address(0),
      value: 0,
      signature: 'execute()',
      calldatas: '',
      withDelegateCall: true
    });

    address polygonPayload = address(0);
    payloadData[1] = PayloadData({
      target: AaveGovernanceV2.CROSSCHAIN_FORWARDER_POLYGON,
      value: 0,
      signature: 'execute(address)',
      calldatas: abi.encode(polygonPayload),
      withDelegateCall: true
    });

    address polygonATokensPayload = address(0);
    payloadData[2] = PayloadData({
      target: AaveGovernanceV2.CROSSCHAIN_FORWARDER_POLYGON,
      value: 0,
      signature: 'execute(address)',
      calldatas: abi.encode(polygonATokensPayload),
      withDelegateCall: true
    });

    address optimismPayload = address(0);
    payloadData[3] = PayloadData({
      target: AaveGovernanceV2.CROSSCHAIN_FORWARDER_OPTIMISM,
      value: 0,
      signature: 'execute(address)',
      calldatas: abi.encode(optimismPayload),
      withDelegateCall: true
    });

    address arbitrumPayload = address(0);
    payloadData[4] = PayloadData({
      target: CROSSCHAIN_FORWARDER_ARBITRUM,
      value: 0,
      signature: 'execute(address)',
      calldatas: abi.encode(arbitrumPayload),
      withDelegateCall: true
    });

    DeployL1Proposal._deployL1Proposal(payloadData, bytes32(0));
    vm.stopBroadcast();
  }
}
