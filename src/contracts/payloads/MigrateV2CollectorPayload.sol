// SPDX-License-Identifier: MIT
pragma experimental ABIEncoderV2;
pragma solidity >=0.6.0;

import {AToken} from '@aave/core-v2/contracts/protocol/tokenization/AToken.sol';
import {ILendingPool as ILendingPoolForInit} from '@aave/core-v2/contracts/interfaces/ILendingPool.sol';
import {IAaveIncentivesController} from '@aave/core-v2/contracts/interfaces/IAaveIncentivesController.sol';
import {DataTypes, ConfiguratorInputTypes, ILendingPool} from 'aave-address-book/AaveV2.sol';
import {AaveMigrationCollector} from './AaveMigrationCollector.sol';
import {ICollectorController} from '../../interfaces/v2/ICollectorController.sol';
import {ILendingPoolConfigurator} from '../../interfaces/v2/ILendingPoolConfigurator.sol';
import {IInitializableAdminUpgradeabilityProxyV2} from '../../interfaces/v2/IInitializableAdminUpgradeabilityProxyV2.sol';

contract MigrateV2CollectorPayload {
  ILendingPool public immutable POOL;
  ILendingPoolConfigurator public immutable POOL_CONFIGURATOR;
  IInitializableAdminUpgradeabilityProxyV2 public immutable COLLECTOR_PROXY;
  IAaveIncentivesController public immutable INCENTIVES_CONTROLLER;

  address public immutable NEW_COLLECTOR;

  constructor(
    address pool,
    address poolConfigurator,
    address v2collector,
    address collector,
    address incentivesController
  ) public {
    POOL = ILendingPool(pool);
    POOL_CONFIGURATOR = ILendingPoolConfigurator(poolConfigurator);
    COLLECTOR_PROXY = IInitializableAdminUpgradeabilityProxyV2(v2collector);
    NEW_COLLECTOR = collector;
    INCENTIVES_CONTROLLER = IAaveIncentivesController(incentivesController);
  }

  function execute() external {
    address[] memory reserves = POOL.getReservesList();

    address[] memory aTokens = updateATokens(reserves);

    transferAssetsAndClaimRewards(aTokens);
  }

  function updateATokens(address[] memory reserves) internal returns (address[] memory) {
    // deploy new aToken implementation
    AToken aTokenImplementation = new AToken();
    DataTypes.ReserveData memory reserveData;
    address[] memory aTokens = new address[](reserves.length);

    for (uint256 i = 0; i < reserves.length; i++) {
      reserveData = POOL.getReserveData(reserves[i]);
      AToken aToken = AToken(reserveData.aTokenAddress);
      aTokens[i] = reserveData.aTokenAddress;

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
    }

    // initialise aTokenImpl for security reasons
    aTokenImplementation.initialize(
      ILendingPoolForInit(address(POOL)),
      NEW_COLLECTOR,
      0x63a72806098Bd3D9520cC43356dD78afe5D386D9, // AAVE Token
      INCENTIVES_CONTROLLER,
      18,
      'Aave Token',
      'AAVE.e',
      '0x10'
    );

    return aTokens;
  }

  // upgrade collector to the new implementation which will transfer all the assets on the init
  function transferAssetsAndClaimRewards(address[] memory aTokens) internal {
    bytes memory initParams = abi.encodeWithSelector(
      AaveMigrationCollector.initialize.selector,
      aTokens,
      address(INCENTIVES_CONTROLLER),
      NEW_COLLECTOR
    );

    AaveMigrationCollector migrationCollector = new AaveMigrationCollector();
    COLLECTOR_PROXY.upgradeToAndCall(address(migrationCollector), initParams);
  }
}
