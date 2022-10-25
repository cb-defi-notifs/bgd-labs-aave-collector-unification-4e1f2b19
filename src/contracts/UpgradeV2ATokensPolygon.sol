// SPDX-License-Identifier: MIT
pragma experimental ABIEncoderV2;
pragma solidity >=0.6.0;

import {AToken} from '@aave/core-v2/contracts/protocol/tokenization/AToken.sol';
import {LendingPoolConfigurator} from '@aave/core-v2/contracts/protocol/lendingpool/LendingPoolConfigurator.sol';
import {DataTypes, ConfiguratorInputTypes} from 'aave-address-book/AaveV2.sol';
import {AaveV2Polygon} from 'aave-address-book/AaveV2Polygon.sol';
import {ICollectorController} from '../interfaces/ICollectorController.sol';
import {ILendingPoolConfiguratorV2} from '../interfaces/ILendingPoolConfiguratorV2.sol';

contract UpgradeV2ATokensPayload {
  ILendingPoolConfiguratorV2 public immutable V2_CONFIGURATOR;
  ICollectorController public immutable V2_COLLECTOR_CONTROLLER;
  address public immutable NEW_COLLECTOR;

  constructor(
    ICollectorController v2CollectorController,
    address v2Collector,
    address newCollector
  ) public {
    V2_CONFIGURATOR = ILendingPoolConfiguratorV2(address(AaveV2Polygon.POOL_CONFIGURATOR));
    V2_COLLECTOR_CONTROLLER = ICollectorController(AaveV2Polygon.COLLECTOR_CONTROLLER);
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
      V2_COLLECTOR_CONTROLLER.transfer(AaveV2Polygon.COLLECTOR, aToken, NEW_COLLECTOR, balance);

      // update implementation of the aToken and reinit
      ConfiguratorInputTypes.UpdateATokenInput memory input = ConfiguratorInputTypes
        .UpdateATokenInput({
          asset: aToken.UNDERLYING_ASSET_ADDRESS(),
          treasury: AaveV2Polygon.COLLECTOR,
          incentivesController: address(aToken.getIncentivesController()),
          name: aToken.name(),
          symbol: aToken.symbol(),
          implementation: address(aTokenImplementation),
          params: '0x10'
        });

      V2_CONFIGURATOR.updateAToken(input);

      // TODO: init AToken contract with some mock stuff
    }
  }
}
