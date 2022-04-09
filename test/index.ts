import { expect } from "chai";
import { ethers } from "hardhat";

describe("Greeter", function () {
  it("Should return the new greeting once it's changed", async function () {
    const Greeter = await ethers.getContractFactory("Greeter");
    const greeter = await Greeter.deploy("Hello, world!");
    await greeter.deployed();

    expect(await greeter.greet()).to.equal("Hello, world!");

    const setGreetingTx = await greeter.setGreeting("Hola, mundo!");

    // wait until the transaction is mined
    await setGreetingTx.wait();

    expect(await greeter.greet()).to.equal("Hola, mundo!");
  });
});

describe("SquadRelative", function () {
  it("Should have a GIF minted for owner of made Pancake Squad Gif", async function () {
    const [owner, usr1] = await ethers.getSigners();
    const PancakeSquad = await ethers.getContractFactory("PancakeSquad");
    const pancakeSquad = await PancakeSquad.deploy(
      "Pancake Squad",
      "PS",
      10000
    );
    await pancakeSquad.connect(owner).mint(usr1.address, 8483);
    const SquadRelativeMaster = await ethers.getContractFactory(
      "SquadRelativeMaster"
    );
    const squadRelativeMaster = await SquadRelativeMaster.deploy(
      "Squad Relative Collector",
      "SRC",
      130,
      pancakeSquad.address
    );
    await squadRelativeMaster.connect(usr1).mintOnBehalfOfCaller(8483);
    const SquadRelative = await ethers.getContractFactory("SquadRelative");
    const deployedSquadRelative = SquadRelative.attach(
      await squadRelativeMaster.getSquadRelativeAddress()
    );
    expect(await deployedSquadRelative.balanceOf(usr1.address)).eq(0);
  });
});
