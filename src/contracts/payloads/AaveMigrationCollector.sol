// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;

import {IERC20} from '@aave/core-v2/contracts/dependencies/openzeppelin/contracts/IERC20.sol';
import {VersionedInitializable} from '../../interfaces/v2/VersionedInitializable.sol';

/**
 * @title AaveMigrationCollector
 * @notice Migrates all assets from this proxy to the new Collector
 * @author Aave
 **/
contract AaveMigrationCollector is VersionedInitializable {
  uint256 public constant REVISION = 2;

  address public RECIPIENT;

  /**
   * @dev returns the revision of the implementation contract
   */
  function getRevision() internal pure override returns (uint256) {
    return REVISION;
  }

  /**
   * @dev returns the recipient collector
   */
  function getRecipient() internal view returns (address) {
    return RECIPIENT;
  }

  /**
   * @dev initializes the contract upon assignment to the InitializableAdminUpgradeabilityProxy
   * migrates all the assets to the new controller
   */
  function initialize(address[] calldata assets, address recipient) external initializer {
    RECIPIENT = recipient;

    transferToRecipient(assets);
  }

  /**
   * @dev initializes the contract upon assignment to the InitializableAdminUpgradeabilityProxy
   * migrates all the assets to the new controller
   */
  function transferToRecipient(address[] calldata assets) public {
    for (uint256 i = 0; i < assets.length; i++) {
      IERC20 token = IERC20(assets[i]);
      uint256 balance = token.balanceOf(address(this));
      if (balance > 0) {
        token.transfer(RECIPIENT, balance);
      }
    }
  }
}
