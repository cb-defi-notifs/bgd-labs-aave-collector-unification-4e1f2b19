// SPDX-License-Identifier: MIT
pragma experimental ABIEncoderV2;
pragma solidity >=0.6.0;

import {AToken} from '@aave/core-v2/contracts/protocol/tokenization/AToken.sol';
import {ILendingPool} from '@aave/core-v2/contracts/interfaces/ILendingPool.sol';
import {IAaveIncentivesController} from '@aave/core-v2/contracts/interfaces/IAaveIncentivesController.sol';
import {DataTypes, ConfiguratorInputTypes} from 'aave-address-book/AaveV2.sol';
import {AaveV2Avalanche} from 'aave-address-book/AaveV2Avalanche.sol';
import {AaveMigrationCollector} from './AaveMigrationCollector.sol';
import {ICollectorController} from '../../interfaces/v2/ICollectorController.sol';
import {ILendingPoolConfigurator} from '../../interfaces/v2/ILendingPoolConfigurator.sol';
import {IInitializableAdminUpgradeabilityProxyV2} from '../../interfaces/v2/IInitializableAdminUpgradeabilityProxyV2.sol';

contract UpgradeV2ATokensAvalanche {
  ILendingPoolConfigurator public immutable POOL_CONFIGURATOR;
  IInitializableAdminUpgradeabilityProxyV2 public immutable COLLECTOR_PROXY;
  address public constant NEW_COLLECTOR = 0x5ba7fd868c40c16f7aDfAe6CF87121E13FC2F7a0;

  constructor() public {
    POOL_CONFIGURATOR = ILendingPoolConfigurator(address(AaveV2Avalanche.POOL_CONFIGURATOR));
    COLLECTOR_PROXY = IInitializableAdminUpgradeabilityProxyV2(AaveV2Avalanche.COLLECTOR);
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
    }

    // initialise aTokenImpl for security reasons
    aTokenImplementation.initialize(
      ILendingPool(address(AaveV2Avalanche.POOL)),
      NEW_COLLECTOR,
      0x63a72806098Bd3D9520cC43356dD78afe5D386D9, // AAVE Token
      IAaveIncentivesController(0x01D83Fe6A10D2f2B7AF17034343746188272cAc9),
      18,
      'Aave Token',
      'AAVE.e',
      '0x10'
    );
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
