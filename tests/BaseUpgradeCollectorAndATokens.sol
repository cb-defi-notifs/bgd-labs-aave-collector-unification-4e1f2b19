// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from 'forge-std/Test.sol';
import {Ownable} from 'solidity-utils/contracts/oz-common/Ownable.sol';
import {ILendingPool, DataTypes} from 'aave-address-book/AaveV2.sol';
import {AaveGovernanceV2} from 'aave-address-book/AaveGovernanceV2.sol';
import {AaveV2Ethereum} from 'aave-address-book/AaveV2Ethereum.sol';
import {ProxyHelpers} from 'aave-helpers/ProxyHelpers.sol';
import {ICollector} from '../src/interfaces/ICollector.sol';
import {IAToken} from '../src/interfaces/IAToken.sol';
import {IInitializableAdminUpgradeabilityProxy} from '../src/interfaces/IInitializableAdminUpgradeabilityProxy.sol';
import {UpgradeAaveCollectorPayloadL2} from '../src/contracts/payloads/UpgradeAaveCollectorPayloadL2.sol';
import {UpgradeCollectorAndATokens} from '../src/contracts/payloads/UpgradeCollectorAndATokens.sol';
import {Collector} from '../src/contracts/Collector.sol';
import {MockExecutor} from './MockExecutor.sol';

abstract contract BaseUpgradeCollectorAndATokens is Test {
  UpgradeCollectorAndATokens public payload;
  ILendingPool internal _v2pool;
  address internal _v2collector;
  address internal _collector;
  address internal _newFundsAdmin;

  MockExecutor internal _executor;

  function _setUp(
    ILendingPool v2pool,
    address v2collector,
    address collector,
    address newFundsAdmin,
    address aclAdmin,
    string memory upgradeATokensArtifact
  ) public {
    _v2pool = v2pool;
    _v2collector = v2collector;
    _collector = collector;
    _newFundsAdmin = newFundsAdmin;

    UpgradeAaveCollectorPayloadL2 upgradeCollectorPayload = new UpgradeAaveCollectorPayloadL2(
      collector,
      newFundsAdmin
    );

    address upgradeV2TokensImpl = deployCode(upgradeATokensArtifact);

    payload = new UpgradeCollectorAndATokens(address(upgradeCollectorPayload), upgradeV2TokensImpl);

    MockExecutor mockExecutor = new MockExecutor();
    vm.etch(aclAdmin, address(mockExecutor).code);

    _executor = MockExecutor(aclAdmin);
  }

  function testExecuteAdminAndFundsAdminChanged() public {
    address implBefore = ProxyHelpers.getInitializableAdminUpgradeabilityProxyImplementation(
      vm,
      _collector
    );

    // Act
    _executor.execute(address(payload));

    // Assert
    address implAfter = ProxyHelpers.getInitializableAdminUpgradeabilityProxyImplementation(
      vm,
      _collector
    );

    // implementation should change
    assertTrue(implBefore != implAfter);

    // check fundsAdmin = short executor
    ICollector collector = ICollector(_collector);
    assertEq(collector.getFundsAdmin(), _newFundsAdmin);

    // check that funds admin is not the proxy admin
    vm.expectRevert();
    vm.prank(_newFundsAdmin);

    IInitializableAdminUpgradeabilityProxy(_collector).admin();
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
    _executor.execute(address(payload));

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
