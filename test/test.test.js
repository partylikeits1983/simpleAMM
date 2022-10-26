const { expect } = require("chai");
const { parseUnits } = require("ethers/lib/utils");
const { ethers, network } = require("hardhat");

describe("Chainlink Oracle Tests", () => {

  let accounts;

  // main
  let oracle;

  before(async () => {
    accounts = await ethers.getSigners();
  });

  it("Should deploy chainlink oracle contract: ", async () => {
    Test = await ethers.getContractFactory("Test");
    oracle = await Test.deploy();
    await oracle.deployed();
  });

  it("Should call init function", async () => {
    let tx = await oracle.connect(accounts[0]).initAddresses();
    await tx.wait();
  });

  it("Should verify addresses in contract", async () => {
    let tx = await oracle.DataAddresses(WETH);
    
    // expect(tx.token).to.be.equal(WETH);

  });

});

