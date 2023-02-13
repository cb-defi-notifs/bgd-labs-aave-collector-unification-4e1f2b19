// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ProxyAdmin} from 'solidity-utils/contracts/transparent-proxy/ProxyAdmin.sol';
import {Collector} from '../Collector.sol';
import {IInitializableAdminUpgradeabilityProxy} from '../../interfaces/IInitializableAdminUpgradeabilityProxy.sol';
import {ICollector} from '../../interfaces/ICollector.sol';

contract UpgradeAaveCollectorPayload {
  // v3 collector proxy address
  IInitializableAdminUpgradeabilityProxy public immutable COLLECTOR_PROXY;

  // short executor or guardian address
  address public immutable NEW_FUNDS_ADMIN;

  // streamId
  uint256 public immutable STREAM_ID;

  constructor(address proxy, address newFundsAdmin, uint256 streamId) {
    COLLECTOR_PROXY = IInitializableAdminUpgradeabilityProxy(proxy);
    NEW_FUNDS_ADMIN = newFundsAdmin;
    STREAM_ID = streamId;
  }

  function execute() external {
    // Deploy proxy admin
    ProxyAdmin proxyAdmin = new ProxyAdmin();

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
    COLLECTOR_PROXY.changeAdmin(address(proxyAdmin));
  }
}
