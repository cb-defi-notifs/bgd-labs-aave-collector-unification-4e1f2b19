// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ProxyAdmin} from 'solidity-utils/contracts/transparent-proxy/ProxyAdmin.sol';
import {Collector} from '../Collector.sol';
import {IInitializableAdminUpgradeabilityProxy} from '../../interfaces/IInitializableAdminUpgradeabilityProxy.sol';
import {ICollector} from '../../interfaces/ICollector.sol';

// TODO: should it be ownable? or no difference
contract UpgradeAaveCollectorPayloadL1 {
  // collector proxy address
  IInitializableAdminUpgradeabilityProxy public constant PROXY =
    IInitializableAdminUpgradeabilityProxy(0x464C71f6c2F760DdA6093dCB91C24c39e5d6e18c);

  // streamable interface of the current collector
  ICollector public constant COLLECTOR = ICollector(0x464C71f6c2F760DdA6093dCB91C24c39e5d6e18c);

  address public constant GOV_SHORT_EXECUTOR = 0xEE56e2B3D491590B5b31738cC34d5232F378a8D5;

  function execute() external {
    // Deploy proxy admin
    // TODO: check if we need another contract for IInitializableAdminUpgradeabilityProxy
    ProxyAdmin proxyAdmin = new ProxyAdmin();

    // Deploy new collector
    Collector collectorImpl = new Collector();

    // Upgrade of both treasuries' implementation
    PROXY.upgradeTo(address(collectorImpl));

    // Update proxy admin
    PROXY.changeAdmin(address(proxyAdmin));

    // Get current stream id
    uint256 nextStreamId = COLLECTOR.getNextStreamId();

    // Initialise the implementation, for security
    COLLECTOR.initialize(GOV_SHORT_EXECUTOR);

    // Initialise the implementation, for security
    collectorImpl.initialize(GOV_SHORT_EXECUTOR);

    // Set actual sream id
    COLLECTOR.setNextStreamId(nextStreamId);
  }
}
