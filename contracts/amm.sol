// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "contracts/dependencies/openzeppelin/SafeERC20.sol";
import "./math.sol";

import "hardhat/console.sol";

contract AMM {
	using Math for int256;
	using SafeERC20 for IERC20; 

	
	struct Pool {
		address token0;
		address token1;

		uint amount0;
		uint amount1;
	}

	struct Position {
		uint amount0;
		uint amount1;
	}

	mapping(uint => Pool) public Pools;

	mapping(address => Position) public Positions;

	uint[] public PIDs;

	// X * Y = K

	// pool = 10x & 5y
	// 2x = 1y

	// exchange rate = (10x / 5y)
	// exchange_rate = 2
	// 2 * amount y + amount x = 20 
	// TVL = 20x

	function TVL(uint PID, address token0) public view returns (int rate, int tvl) {
		address poolX = Pools[PID].token0;

		if (token0 == poolX) {
			int amountX = int(Pools[PID].amount0);
			int amountY = int(Pools[PID].amount1);

			rate = amountX.div(amountY);
			tvl = rate.mul(amountY) + amountX;
		} 
		else {
			int amountX = int(Pools[PID].amount1);
			int amountY = int(Pools[PID].amount0);

			rate = amountX.div(amountY);
			tvl = rate.mul(amountY) + amountX;
		}

		return (rate, tvl);
	}

	function ExchangeRate(uint PID, address token0) public view returns (int rate) {
		address poolX = Pools[PID].token0;

		if (token0 == poolX) {
			int amountX = int(Pools[PID].amount0);
			int amountY = int(Pools[PID].amount1);

			rate = amountX.div(amountY);
		} 
		else {
			int amountX = int(Pools[PID].amount1);
			int amountY = int(Pools[PID].amount0);

			rate = amountX.div(amountY);
		}
		return rate;
	}

	function numberOfPools() public view returns (uint) {
		return PIDs.length;
	}

	function createPool(address token0, address token1) public returns (uint) {
		uint PID = PIDs.length;

		Pools[PID].token0 = token0;
		Pools[PID].token1 = token1;

		PIDs.push(PID);

		return PID;
	}

	function Deposit(uint PID, uint amount_token0, uint amount_token1) public {
		address token0 = Pools[PID].token0;
		address token1 = Pools[PID].token1;

		require(token0 != address(0), "not initialized X");
		require(token1 != address(0), "not initialized Y");

		IERC20(token0).transferFrom(msg.sender, address(this), amount_token0);
		IERC20(token1).transferFrom(msg.sender, address(this), amount_token1);

		Pools[PID].amount0 += amount_token0;
		Pools[PID].amount1 += amount_token1;

		Positions[msg.sender].amount0 = amount_token0;
		Positions[msg.sender].amount1 = amount_token1;
	}
	
	function getOtherTokenAddr(uint PID, address token0) public view returns (address token1) {
		address poolX = Pools[PID].token0;
		address poolY = Pools[PID].token1;

		if (token0 == poolX) {
			token1 = poolY;
		}
		if (token0 == poolY) {
			token1 = poolY;
		}
		return token1;
	}


	// x = 5
	// y = 10
	// k = x*y
	// dx = 1 
	// k = (x+1) * (y+dy)
	// 50 = (5+1) * (10+dy)
	// 50 = 6 * (10 + dy)
	// 50 = 60+6dy
	// -10 = 6dy
	// -10/6 = dy
	// -1.666
	// amountOut = (-dx*y)/(dx + x)

	// still neet to write tests
	// this is not working... 
	function Swap(uint PID, address tokenIn, uint amount) public returns (uint) {
		require(IERC20(tokenIn).transferFrom(msg.sender, address(this), amount));

		address tokenOut = getOtherTokenAddr(PID, tokenIn);
		int amountOut;

		if(Pools[PID].token0 == tokenIn) {
			// amount out Y
			Pools[PID].amount0 += amount;
			amountOut = int(amount).mul(int(Pools[PID].amount1)).div(int(amount + Pools[PID].amount0));

			Pools[PID].amount1 -= uint(amountOut);

			console.log("Amount Out");
			console.logInt(amountOut);
		}
		else {
			// amount out X
			Pools[PID].amount1 += amount;
			amountOut = int(amount).mul(int(Pools[PID].amount0)).div(int(amount + Pools[PID].amount1));

			Pools[PID].amount0 -= uint(amountOut);

			console.logInt(amountOut);

		}
		// transfer amount token out
		IERC20(tokenOut).transfer(msg.sender, uint(amountOut));

		console.log("New Exchange Rate:");
		console.logInt(ExchangeRate(PID,tokenIn));

		return uint(amountOut);
	}
	

}
