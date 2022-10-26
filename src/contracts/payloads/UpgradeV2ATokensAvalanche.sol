// SPDX-License-Identifier: MIT
pragma experimental ABIEncoderV2;
pragma solidity >=0.6.0;

import {AToken} from '@aave/core-v2/contracts/protocol/tokenization/AToken.sol';
import {LendingPoolConfigurator} from '@aave/core-v2/contracts/protocol/lendingpool/LendingPoolConfigurator.sol';
import {DataTypes, ConfiguratorInputTypes} from 'aave-address-book/AaveV2.sol';
import {AaveV2Avalanche} from 'aave-address-book/AaveV2Avalanche.sol';
import {AaveMigrationCollector} from './AaveMigrationCollector.sol';
import {ICollectorController} from '../../interfaces/v2/ICollectorController.sol';
import {ILendingPoolConfigurator} from '../../interfaces/v2/ILendingPoolConfigurator.sol';
import {IInitializableAdminUpgradeabilityProxyV2} from '../../interfaces/v2/IInitializableAdminUpgradeabilityProxyV2.sol';

contract UpgradeV2ATokensPayload {
  ILendingPoolConfigurator public immutable POOL_CONFIGURATOR;
  IInitializableAdminUpgradeabilityProxyV2 public immutable COLLECTOR_PROXY;
  address public immutable NEW_COLLECTOR;

  constructor(address newCollector) public {
    POOL_CONFIGURATOR = ILendingPoolConfigurator(address(AaveV2Avalanche.POOL_CONFIGURATOR));
    COLLECTOR_PROXY = IInitializableAdminUpgradeabilityProxyV2(AaveV2Avalanche.COLLECTOR);
    NEW_COLLECTOR = newCollector;
  }

  function execute() external {
    address[] memory reserves = AaveV2Avalanche.POOL.getReservesList();

    updateATokens(reserves);

    migrateAssetsToNewCollector(reserves);
  }

  function updateATokens(address[] memory reserves) internal {
    // deploy new aToken implementation
    AToken aTokenImplementation = new AToken();
    DataTypes.ReserveData memory reserveData;

    for (uint256 i = 0; i < reserves.length; i++) {
      reserveData = AaveV2Avalanche.POOL.getReserveData(reserves[i]);
      AToken aToken = AToken(reserveData.aTokenAddress);

      // update implementation of the aToken and re-init
      ConfiguratorInputTypes.UpdateATokenInput memory input = ConfiguratorInputTypes
        .UpdateATokenInput({
          asset: aToken.UNDERLYING_ASSET_ADDRESS(),
          treasury: NEW_COLLECTOR,
          incentivesController: address(aToken.getIncentivesController()),
          name: aToken.name(),
          symbol: aToken.symbol(),
          implementation: address(aTokenImplementation),
          params: '0x10'
        });

      POOL_CONFIGURATOR.updateAToken(input);
      // TODO: init AToken contract with some mock stuff for security reasons
    }
  }

  // upgrade collector to the new implementation which will transfer all the assets on the init
  function migrateAssetsToNewCollector(address[] memory reserves) internal {
    bytes memory initParams = abi.encodeWithSelector(
      AaveMigrationCollector.initialize.selector,
      reserves,
      NEW_COLLECTOR
    );

    AaveMigrationCollector migrationCollector = new AaveMigrationCollector();
    COLLECTOR_PROXY.upgradeToAndCall(address(migrationCollector), initParams);
  }
}
