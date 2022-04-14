// scripts/upgrade-box.js
const { ethers, upgrades } = require("hardhat");

async function main() {
  
  
  const contractName = "ElvenWallet"
  const address = "0x760576ac349439ea3505a6ff668a26ecf61d2224"

  const ContractFactory = await ethers.getContractFactory(contractName);
  const upgraded = await upgrades.upgradeProxy(address, ContractFactory);
  
  console.log("upgraded");

  
}

main();