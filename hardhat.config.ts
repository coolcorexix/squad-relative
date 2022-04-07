import * as dotenv from "dotenv";

import { HardhatUserConfig, task } from "hardhat/config";
import "@nomiclabs/hardhat-etherscan";
import "@nomiclabs/hardhat-waffle";
import "@typechain/hardhat";
import "hardhat-gas-reporter";
import "solidity-coverage";

dotenv.config();

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

task("setGreetings", "test greeting account", async (taskArgs, hre) => {
  const Greeter = await hre.ethers.getContractFactory("Greeter");

  const greeter = Greeter.attach("0x5FbDB2315678afecb367f032d93F642f64180aa3");
  await greeter.setGreeting("Xin chao, world!");
});

task("callGreetings", "test greeting account", async (taskArgs, hre) => {
  const Greeter = await hre.ethers.getContractFactory("Greeter");

  const greeter = Greeter.attach("0x5FbDB2315678afecb367f032d93F642f64180aa3");
  const rs = await greeter.greet();
  console.log("🚀 ~ file: hardhat.config.ts ~ line 34 ~ task ~ rs", rs);
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

const config: HardhatUserConfig = {
  solidity: "0.8.4",
  networks: {
    ropsten: {
      url: process.env.ROPSTEN_URL || "",
      accounts:
        process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
    },
  },
  gasReporter: {
    enabled: process.env.REPORT_GAS !== undefined,
    currency: "USD",
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY,
  },
};

export default config;
