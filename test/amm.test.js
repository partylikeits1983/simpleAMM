const { expect } = require("chai");
const { parseUnits } = require("ethers/lib/utils");
const { ethers, network } = require("hardhat");

describe("Chainlink Oracle Tests", () => {

  let accounts;

  // main
  let ammSwap;

  let tokenX;
  let tokenY;

  before(async () => {
    accounts = await ethers.getSigners();
  });

  it("Should deploy math library: ", async () => {
    MATH = await ethers.getContractFactory("Math");
    math = await MATH.deploy();
    await math.deployed();
  });

  it("Should deploy AMM swap contract: ", async () => {
    AMM = await ethers.getContractFactory("AMM", {
        libraries: {
            Math: math.address
        }
    });
    ammSwap = await AMM.deploy();
    await ammSwap.deployed();
  });

  it("Should deploy token X: ", async () => {
    const TOKENX = await ethers.getContractFactory("ERC20");

    let amount = ethers.utils.parseUnits("1000000");

    tokenX = await TOKENX.deploy("TokenX", "X", amount);
    await tokenX.deployed();

    console.log("token X address:", tokenX.address);
  });

  it("Should deploy token Y: ", async () => {
    const TOKENY = await ethers.getContractFactory("ERC20");

    let amount = ethers.utils.parseUnits("1000000");

    tokenY = await TOKENY.deploy("TokenY", "Y", amount);
    await tokenY.deployed();
    console.log("token Y address:", tokenY.address);

  });

  it("Should create pool: ", async () => {
    let tx = await ammSwap.createPool(tokenX.address, tokenY.address);
    await tx.wait();
    // console.log(tx);
  });

  it("Should get pool values: ", async () => {
    let PID = await ammSwap.numberOfPools();

    console.log("number of pools",PID);
    let tx = await ammSwap.Pools(0);
    console.log(tx);
  });

  it("Should deposit", async () => {

    let amount0 = ethers.utils.parseUnits("100000");
    let amount1 = ethers.utils.parseUnits("50000");

    await tokenX.connect(accounts[0]).approve(ammSwap.address, amount0);
    await tokenY.connect(accounts[0]).approve(ammSwap.address, amount1);

    let PID = await ammSwap.numberOfPools() - 1;
    console.log(PID);

    await ammSwap.connect(accounts[0]).Deposit(PID, amount0, amount1);
  });


  it("Should get exchange rate", async () => {
    let PID = await ammSwap.numberOfPools() - 1;

    let rate = await ammSwap.ExchangeRate(PID, tokenX.address, tokenY.address);

    console.log("exchange rate:", rate);

  });

  it("Should swap", async () => {
    let amount = ethers.utils.parseUnits("100");

    let PID = await ammSwap.numberOfPools() - 1;

    let rate = await ammSwap.Swap(PID, tokenX.address, amount);

    console.log("exchange rate:", rate);

  });


});

