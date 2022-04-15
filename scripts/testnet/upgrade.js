// scripts/upgrade-box.js
const { ethers, upgrades } = require("hardhat");

async function main() {
  
  
  const contractName = "EETest"
  const address = "0x45da7f88a52b84ac6f6d52b083fbf3f9f5c26579"

  const ContractFactory = await ethers.getContractFactory(contractName);
  const upgraded = await upgrades.upgradeProxy(address, ContractFactory);
  
  console.log("upgraded");

  
}

main();