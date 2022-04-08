import { ethers } from "hardhat";

async function main() {
  const PancakeSquad = await ethers.getContractFactory("PancakeSquad");
  const pancakeSquad = await PancakeSquad.deploy(
    "Pancake Squad Testnet",
    "PSQD",
    100
  );
  console.log("Pancake squad deployed to:", pancakeSquad.address);
}

main().catch((err) => {
  console.error(err);
  process.exitCode = 1;
});
