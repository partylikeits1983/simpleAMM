// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

import "../src/amm.sol";
import "../src/token.sol";

contract AMM_test is Test {

    AMM public amm;

    Token public token_0;
    Token public token_1; 

    function setUp() public {
        string memory name_0 = "Token 0";
        string memory symbol_0 = "TKN_0";
        string memory name_1 = "Token 1";
        string memory symbol_1 = "TKN_1";

        token_0 = new Token(name_0, symbol_0);
        token_1 = new Token(name_1, symbol_1);

        amm = new AMM();
    }

    function testCallAMM() public {
        uint PID = amm.createPool(address(token_0), address(token_1));

        assertEq(PID, 0);
    }

    function testDepositAMM() public {
        uint PID = amm.createPool(address(token_0), address(token_1));

        uint amount_0 = 1000e18;
        uint amount_1 = 1000e18;

        token_0.approve(address(amm), amount_0);
        token_1.approve(address(amm), amount_1);

        amm.deposit(PID, amount_0, amount_1);

        int rate = amm.ExchangeRate(PID, address(token_0));

        console.logInt(rate);

        assertEq(rate, 1e18);
    }



/* 
    function testGetUSDC() public {
        address user = 0x28f1d5FE896dB571Cba7679863DD4E1272d49eAc;
        uint usdcBalance = usdc.balanceOf(user);

        vm.prank(user);

        usdc.approve(address(this), usdcBalance);
        vm.prank(user);

        usdc.transfer(address(this), usdcBalance);

        assertEq(usdc.balanceOf(address(this)), usdcBalance);

        console.logUint(usdcBalance);
        console.logUint(usdc.balanceOf(address(this)));
    }

 */


}