// scripts/upgrade-box.js
const { ethers, upgrades } = require("hardhat");
//0x3cF1630393BFd1D9fF52bD822fE88714FC81467E
async function main() {
  const Inventory = await ethers.getContractFactory("EldersInventoryManager");
  const inventory = await upgrades.upgradeProxy("0x3785cb370a473a186b79efd9ea49e5f638715206", Inventory);
  console.log("upgraded");
}

main();