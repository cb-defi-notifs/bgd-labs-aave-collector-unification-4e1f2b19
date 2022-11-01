// SPDX-License-Identifier: MIT
pragma experimental ABIEncoderV2;
pragma solidity >=0.6.0;

import {AToken} from '@aave/core-v2/contracts/protocol/tokenization/AToken.sol';
import {ILendingPool} from '@aave/core-v2/contracts/interfaces/ILendingPool.sol';
import {IAaveIncentivesController} from '@aave/core-v2/contracts/interfaces/IAaveIncentivesController.sol';
import {DataTypes, ConfiguratorInputTypes} from 'aave-address-book/AaveV2.sol';
import {AaveV2Polygon} from 'aave-address-book/AaveV2Polygon.sol';
import {ICollectorController} from '../../interfaces/v2/ICollectorController.sol';
import {ILendingPoolConfigurator} from '../../interfaces/v2/ILendingPoolConfigurator.sol';

contract UpgradeV2ATokensPolygon {
  ILendingPoolConfigurator public immutable POOL_CONFIGURATOR;
  ICollectorController public immutable COLLECTOR_CONTROLLER;
  address public constant NEW_COLLECTOR = 0xe8599F3cc5D38a9aD6F3684cd5CEa72f10Dbc383;

  constructor() public {
    POOL_CONFIGURATOR = ILendingPoolConfigurator(address(AaveV2Polygon.POOL_CONFIGURATOR));
    COLLECTOR_CONTROLLER = ICollectorController(AaveV2Polygon.COLLECTOR_CONTROLLER);
  }

  function execute() external {
    AToken aTokenImplementation = new AToken();

    // get all aTokens
    DataTypes.ReserveData memory reserveData;
    address[] memory reserves = AaveV2Polygon.POOL.getReservesList();

    for (uint256 i = 0; i < reserves.length; i++) {
      reserveData = AaveV2Polygon.POOL.getReserveData(reserves[i]);
      AToken aToken = AToken(reserveData.aTokenAddress);

      // send asset to the new collector
      uint256 balance = aToken.balanceOf(AaveV2Polygon.COLLECTOR);
      if (balance > 0) {
        COLLECTOR_CONTROLLER.transfer(AaveV2Polygon.COLLECTOR, aToken, NEW_COLLECTOR, balance);
      }

      // update implementation of the aToken and reinit
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
      ILendingPool(address(AaveV2Polygon.POOL)),
      NEW_COLLECTOR,
      0xD6DF932A45C0f255f85145f286eA0b292B21C90B, // AAVE Token
      IAaveIncentivesController(0x357D51124f59836DeD84c8a1730D72B749d8BC23),
      18,
      'Aave (PoS)',
      'AAVE',
      '0x10'
    );
  }
}
