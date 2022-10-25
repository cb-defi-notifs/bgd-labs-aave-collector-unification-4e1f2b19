// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import {ProxyAdmin} from 'solidity-utils/contracts/transparent-proxy/ProxyAdmin.sol';
import {Collector} from './Collector.sol';
import {IInitializableAdminUpgradeabilityProxy} from '../interfaces/IInitializableAdminUpgradeabilityProxy.sol';
import {IStreamable} from '../interfaces/IStreamable.sol';

contract UpgradeAaveCollectorPayloadL2 {
  // collector proxy address
  IInitializableAdminUpgradeabilityProxy public constant COLLECTOR_PROXY =
    IInitializableAdminUpgradeabilityProxy(
      0x464C71f6c2F760DdA6093dCB91C24c39e5d6e18c
    );

  // streamable interface of the current collector
  IStreamable public constant CURRENT_COLLECTOR_STREAMABLE =
    IStreamable(0x464C71f6c2F760DdA6093dCB91C24c39e5d6e18c);

  address public constant GOV_SHORT_EXECUTOR =
    0xEE56e2B3D491590B5b31738cC34d5232F378a8D5;

  function execute() external {
    // Get current stream id
    uint256 nextStreamId = CURRENT_COLLECTOR_STREAMABLE.getNextStreamId();

    // Deploy proxy admin
    // TODO: check if we need another contract for IInitializableAdminUpgradeabilityProxy
    ProxyAdmin proxyAdmin = new ProxyAdmin();

    // Deploy new collector
    Collector collector = new Collector();

    // Upgrade of both treasuries' implementation
    COLLECTOR_PROXY.upgradeToAndCall(
      address(collector),
      abi.encodeWithSelector(
        IStreamable.initialize.selector,
        GOV_SHORT_EXECUTOR
      )
    );

    // Initialise the implementation, for security
    collector.initialize(GOV_SHORT_EXECUTOR);

    // Set actual sream id
    collector.setNextStreamId(nextStreamId);

    // Update proxy admin
    COLLECTOR_PROXY.changeAdmin(address(proxyAdmin));
  }
}
