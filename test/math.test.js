const { expect } = require("chai");
const { parseUnits } = require("ethers/lib/utils");
const { ethers, network } = require("hardhat");

describe("AMM Test", () => {
  let accounts;

  // main
  let math;

  before(async () => {
    accounts = await ethers.getSigners();
  });

  it("Should deploy math contract: ", async () => {
    const Math = await ethers.getContractFactory("Math");
    math = await Math.deploy();
    await math.deployed();
  });
 
  it("Should call mul function", async () => {
    let a = ethers.utils.parseUnits("5");
    let b = ethers.utils.parseUnits("9");

    let tx = await math.mul(a, b);
    // await tx.wait();

    console.log("Mul", tx);
  });

  it("Should call div function", async () => {
    let a = ethers.utils.parseUnits("5");
    let b = ethers.utils.parseUnits("9");

    let tx = await math.div(a, b);
    // await tx.wait();

    console.log("div", tx);
  });

});

