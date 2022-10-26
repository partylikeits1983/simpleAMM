// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "hardhat/console.sol";

contract Test {

	function test(uint a, uint b) public pure returns (uint) {
		return a+b;
	}
}
