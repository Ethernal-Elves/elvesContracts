// scripts/upgrade-box.js
const { ethers, upgrades } = require("hardhat");
//MAIN 0x13bdee5dfe487a055f3fa523fecdcf8ecdd3b889 EthernalElves
//INVENTORY 0xB8b20372bf0880359d96a3c5e51C09F670C80b87 ElfMetadataHandler
async function main() {
  const Elves = await ethers.getContractFactory("ElvenWalletV2");
  const elves = await upgrades.upgradeProxy("0x87e8fbe53fa6c1900bcb8511124c65467e0e71bb", Elves);
  console.log("upgraded");
}

main();