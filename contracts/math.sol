// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "contracts/dependencies/prb-math/PRBMathSD59x18.sol";

library Math {
	using PRBMathSD59x18 for int256;

	function mul(int a, int b) public pure returns (int) {
		int c = a.mul(b);
		return c;
	}	

	function div(int a, int b) public pure returns (int) {
		int c = a.div(b); 
		return c;
	}

}
