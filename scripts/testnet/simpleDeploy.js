const hre = require("hardhat");

const sleep = (milliseconds) => {
  return new Promise(resolve => setTimeout(resolve, milliseconds))
}

async function main() {

  const SLP = await ethers.getContractFactory("SLP");
  

 const moon = await SLP.deploy();
 await moon.deployed();
 await sleep(20000)
 await hre.run("verify:verify", { address: moon.address }); 

 const contractName = "ElvenWallet"
 const address = "0x760576ac349439ea3505a6ff668a26ecf61d2224"
 await sleep(20000)
 const ContractFactory = await ethers.getContractFactory(contractName);
 const upgraded = await upgrades.upgradeProxy(address, ContractFactory);
 
 console.log("upgraded");

/*
  const dao = await ElvenDao.deploy("0x269f824f32536Ed1B4108968c52BEDEC40AF1663"); 

  await dao.deployed();

  await sleep(60000);
  
  console.log("verifying contracts Dao")
  console.log("Dao:", dao.address)

  await hre.run("verify:verify", { address: "0xf59ff0b32cd2d61a309961dfd34d1dc71f54bf00" }); 
  await sleep(10000);
  await hre.run("verify:verify", { address: "0x269f824f32536Ed1B4108968c52BEDEC40AF1663" });  
  
*/
///npx hardhat verify --network mainnet 0x858c52bbc608435f035b1913ec0228322ac54c2e 
//npx hardhat run scripts/testnet/daoDeploy.js --network hardhat
  
}


main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
