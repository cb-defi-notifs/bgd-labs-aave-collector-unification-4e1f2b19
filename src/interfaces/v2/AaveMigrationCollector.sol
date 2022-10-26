// SPDX-License-Identifier: agpl-3.0
pragma solidity >=0.6.0;

import {IERC20} from '@aave/core-v2/contracts/dependencies/openzeppelin/contracts/IERC20.sol';
import {VersionedInitializable} from './VersionedInitializable.sol';

/**
 * @title AaveMigrationCollector
 * @notice Migrates all assets from this proxy to the new Collector
 * @author Aave
 **/
contract AaveMigrationCollector is VersionedInitializable {
  uint256 public constant REVISION = 2;

  /**
   * @dev returns the revision of the implementation contract
   */
  function getRevision() internal pure override returns (uint256) {
    return REVISION;
  }

  /**
   * @dev initializes the contract upon assignment to the InitializableAdminUpgradeabilityProxy
   * migrates all the assets to the new controller
   */
  function initialize(address[] calldata assets, address recepient) external initializer {
    for (uint256 i = 0; i < assets.length; i++) {
      IERC20 token = IERC20(assets[i]);
      uint256 balance = token.balanceOf(address(this));

      if (balance > 0) {
        token.transfer(recepient, balance);
      }
    }
  }
}
