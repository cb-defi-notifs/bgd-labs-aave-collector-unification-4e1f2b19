// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from 'forge-std/Test.sol';
import {ILendingPool, DataTypes} from 'aave-address-book/AaveV2.sol';
import {IAToken} from '../src/interfaces/IAToken.sol';
import {MockExecutor} from './MockExecutor.sol';

abstract contract BaseATokensTest is Test {
  address internal payload;
  ILendingPool internal _v2pool;
  address internal _v2collector;
  address internal _collector;

  MockExecutor internal _executor;

  function _setUp(
    ILendingPool v2pool,
    address v2collector,
    address collector,
    address aclAdmin,
    string memory upgradeATokensArtifact
  ) public {
    _v2pool = v2pool;
    _v2collector = v2collector;
    _collector = collector;

    payload = deployCode(upgradeATokensArtifact);

    MockExecutor mockExecutor = new MockExecutor();
    vm.etch(aclAdmin, address(mockExecutor).code);

    _executor = MockExecutor(aclAdmin);
  }

  function testExecuteATokensTransferedAndImplUpdated() public {
    // Arrange
    // get all reserves
    DataTypes.ReserveData memory reserveData;
    address[] memory reserves = _v2pool.getReservesList();

    // get balances of collector v2
    IAToken[] memory aTokens = new IAToken[](reserves.length);
    uint256[] memory balancesBefore = new uint256[](reserves.length);

    for (uint256 i = 0; i < reserves.length; i++) {
      reserveData = _v2pool.getReserveData(reserves[i]);
      aTokens[i] = IAToken(reserveData.aTokenAddress);
      balancesBefore[i] = aTokens[i].balanceOf(_v2collector);
    }

    // Act
    _executor.execute(payload);

    // Assert
    for (uint256 i = 0; i < aTokens.length; i++) {
      // check that treasury address is now v3
      assertEq(aTokens[i].RESERVE_TREASURY_ADDRESS(), _collector);

      // check that v2 collector balances = 0
      assertEq(aTokens[i].balanceOf(_v2collector), 0);

      // check that asset was transfered to v3 collector
      assertEq(aTokens[i].balanceOf(_collector), balancesBefore[i]);
    }
  }
}
