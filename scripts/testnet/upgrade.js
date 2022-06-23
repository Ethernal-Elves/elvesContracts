// scripts/upgrade-box.js
const { ethers, upgrades } = require("hardhat");

async function main() {
  
  ///npx hardhat verify --network mumbai 0x881553e236a2a876e66e44c7efdc7be96f94f8fe 

//npx hardhat run scripts/testnet/upgrade.js --network mumbai
  
  const contractName = "Elders" //EETest
  const address = "0x6221dd85a400245f33059f014629f876e4a48ad7" //0x45da7f88a52b84ac6f6d52b083fbf3f9f5c26579

  const ContractFactory = await ethers.getContractFactory(contractName);
  const upgraded = await upgrades.upgradeProxy(address, ContractFactory);
  
  console.log("upgraded");

  
}

main();