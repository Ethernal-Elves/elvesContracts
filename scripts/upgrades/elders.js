///0xfb2b13c622d1590f9199f75d975574e8240b2618

// scripts/upgrade-box.js
const { ethers, upgrades } = require("hardhat");
//MAIN 0x13bdee5dfe487a055f3fa523fecdcf8ecdd3b889 EthernalElves
//INVENTORY 0xB8b20372bf0880359d96a3c5e51C09F670C80b87 ElfMetadataHandler
async function main() {
  const Elves = await ethers.getContractFactory("Elders");
  const elves = await upgrades.upgradeProxy("0xfb2b13c622d1590f9199f75d975574e8240b2618", Elves);
  console.log("upgraded");
}

main();