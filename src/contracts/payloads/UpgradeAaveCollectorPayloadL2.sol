// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ProxyAdmin} from 'solidity-utils/contracts/transparent-proxy/ProxyAdmin.sol';
import {Collector} from '../Collector.sol';
import {IInitializableAdminUpgradeabilityProxy} from '../../interfaces/IInitializableAdminUpgradeabilityProxy.sol';
import {ICollector} from '../../interfaces/ICollector.sol';

contract UpgradeAaveCollectorPayloadL2 {
  // v3 collector proxy address
  IInitializableAdminUpgradeabilityProxy public immutable COLLECTOR_V3_PROXY;

  // short executor or guardian address
  address public immutable NEW_FUNDS_ADMIN;

  constructor(address proxy, address newFundsAdmin) {
    COLLECTOR_V3_PROXY = IInitializableAdminUpgradeabilityProxy(proxy);
    NEW_FUNDS_ADMIN = newFundsAdmin;
  }

  function execute() external {
    // Deploy proxy admin
    // TODO: check if we need another contract for IInitializableAdminUpgradeabilityProxy
    ProxyAdmin proxyAdmin = new ProxyAdmin();

    // Deploy new collector
    Collector collector = new Collector();

    // Upgrade of both treasuries' implementation
    COLLECTOR_V3_PROXY.upgradeToAndCall(
      address(collector),
      abi.encodeWithSelector(ICollector.initialize.selector, NEW_FUNDS_ADMIN)
    );

    // // We initialise the implementation, for security
    collector.initialize(NEW_FUNDS_ADMIN);

    // // Update proxy admin
    COLLECTOR_V3_PROXY.changeAdmin(address(proxyAdmin));
  }
}
