// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Collector} from '../Collector.sol';
import {IInitializableAdminUpgradeabilityProxy} from '../../interfaces/IInitializableAdminUpgradeabilityProxy.sol';
import {ICollector} from '../../interfaces/ICollector.sol';

contract UpgradeAaveCollectorPayload {
  // v3 collector proxy address
  IInitializableAdminUpgradeabilityProxy public immutable COLLECTOR_PROXY;

  // short executor or guardian address
  address public immutable NEW_FUNDS_ADMIN;

  // proxy admin
  address public immutable PROXY_ADMIN;

  // streamId
  uint256 public immutable STREAM_ID;

  constructor(address proxy, address proxyAdmin, address newFundsAdmin, uint256 streamId) {
    COLLECTOR_PROXY = IInitializableAdminUpgradeabilityProxy(proxy);
    PROXY_ADMIN = proxyAdmin;
    NEW_FUNDS_ADMIN = newFundsAdmin;
    STREAM_ID = streamId;
  }

  function execute() external {
    // Deploy new collector
    Collector collector = new Collector();

    // Upgrade of collector implementation
    COLLECTOR_PROXY.upgradeToAndCall(
      address(collector),
      abi.encodeWithSelector(ICollector.initialize.selector, NEW_FUNDS_ADMIN, STREAM_ID)
    );

    // We initialise the implementation, for security
    collector.initialize(NEW_FUNDS_ADMIN, STREAM_ID);

    // Update proxy admin
    COLLECTOR_PROXY.changeAdmin(PROXY_ADMIN);
  }
}
