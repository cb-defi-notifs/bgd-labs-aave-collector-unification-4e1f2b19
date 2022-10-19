// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import {Test} from 'forge-std/Test.sol';

import {Collector} from '../src/contracts/Collector.sol';
import {IERC20} from 'solidity-utils/contracts/oz-common/interfaces/IERC20.sol';

contract CollectorTest is Test {
  Collector public collector;

  IERC20 public constant AAVE =
    IERC20(0xD6DF932A45C0f255f85145f286eA0b292B21C90B);

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('polygon'));

    collector = new Collector();
    collector.initialize(address(this));
    deal(address(AAVE), address(collector), 5 ether);
  }

  function testGetFundsAdmin() public {
    address fundsAdmin = collector.getFundsAdmin();
    assertEq(fundsAdmin, address(this));
  }

  function testSetFundsAdmin() public {
    collector.setFundsAdmin(address(42));

    address fundsAdmin = collector.getFundsAdmin();
    assertEq(fundsAdmin, address(42));
  }

  function testApprove() public {
    collector.approve(AAVE, address(42), 1 ether);

    uint256 allowance = AAVE.allowance(address(collector), address(42));

    assertEq(allowance, 1 ether);
  }

  function testApproveWhenNotFundsAdmin() public {
    vm.expectRevert(bytes('ONLY_BY_FUNDS_ADMIN'));
    vm.prank(address(0));

    collector.approve(AAVE, address(0), 1 ether);
  }

  function testTransfer() public {
    collector.transfer(AAVE, address(112), 1 ether);

    uint256 balance = AAVE.balanceOf(address(112));

    assertEq(balance, 1 ether);
  }

  function testTransferWhenNotFundsAdmin() public {
    vm.expectRevert(bytes('ONLY_BY_FUNDS_ADMIN'));
    vm.prank(address(0));

    collector.transfer(AAVE, address(112), 1 ether);
  }

  // Tests for streams

  function testGetNextStreamId() public {
    uint256 streamId = collector.getNextStreamId();
    assertEq(streamId, 100000);
  }

  function testSetNextStreamId() public {
    collector.setNextStreamId(123456);

    uint256 streamId = collector.getNextStreamId();
    assertEq(streamId, 123456);
  }

  function testSetNextStreamIdWhenInvalid() public {
    vm.expectRevert(bytes('stream id is invalid'));

    collector.setNextStreamId(1);
  }

  function testSetNextStreamIdWhenNotFundsAdmin() public {
    vm.expectRevert(bytes('ONLY_BY_FUNDS_ADMIN'));
    vm.prank(address(0));

    collector.setNextStreamId(123456);
  }

  // createStream

  // get stream

  // deltaOf

  // balanceOf

  // withdraw

  // cancel
}
