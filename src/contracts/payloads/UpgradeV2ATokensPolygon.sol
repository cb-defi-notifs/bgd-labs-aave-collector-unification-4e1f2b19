// SPDX-License-Identifier: MIT
pragma experimental ABIEncoderV2;
pragma solidity >=0.6.0;

import {AToken} from '@aave/core-v2/contracts/protocol/tokenization/AToken.sol';
import {LendingPoolConfigurator} from '@aave/core-v2/contracts/protocol/lendingpool/LendingPoolConfigurator.sol';
import {DataTypes, ConfiguratorInputTypes} from 'aave-address-book/AaveV2.sol';
import {AaveV2Polygon} from 'aave-address-book/AaveV2Polygon.sol';
import {ICollectorController} from '../../interfaces/v2/ICollectorController.sol';
import {ILendingPoolConfigurator} from '../../interfaces/v2/ILendingPoolConfigurator.sol';
import {IERC20V2} from '../../interfaces/v2/IERC20V2.sol';

contract UpgradeV2ATokensPayload {
  ILendingPoolConfigurator public immutable POOL_CONFIGURATOR;
  ICollectorController public immutable COLLECTOR_CONTROLLER;
  address public immutable NEW_COLLECTOR;

  constructor(address newCollector) public {
    POOL_CONFIGURATOR = ILendingPoolConfigurator(address(AaveV2Polygon.POOL_CONFIGURATOR));
    COLLECTOR_CONTROLLER = ICollectorController(AaveV2Polygon.COLLECTOR_CONTROLLER);
    NEW_COLLECTOR = newCollector;
  }

  function execute() public {
    AToken aTokenImplementation = new AToken();

    // get all aTokens
    DataTypes.ReserveData memory reserveData;
    address[] memory reserves = AaveV2Polygon.POOL.getReservesList();

    for (uint256 i = 0; i < reserves.length; i++) {
      reserveData = AaveV2Polygon.POOL.getReserveData(reserves[i]);
      AToken aToken = AToken(reserveData.aTokenAddress);

      // send asset to the new collector
      uint256 balance = aToken.balanceOf(AaveV2Polygon.COLLECTOR);
      COLLECTOR_CONTROLLER.transfer(
        AaveV2Polygon.COLLECTOR,
        IERC20V2(address(aToken)),
        NEW_COLLECTOR,
        balance
      );

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

      // TODO: init AToken contract with some mock stuff for security reasons
    }
  }
}
