// scripts/upgrade-box.js
const { ethers, upgrades } = require("hardhat");

async function main() {
  const Artifacts = await ethers.getContractFactory("Artifacts");
  const art = await upgrades.upgradeProxy("0xDb2E506d2863646C0141f77F2cE9f99bbbB6b8Ab", Artifacts);
  console.log("upgraded");
}

main();