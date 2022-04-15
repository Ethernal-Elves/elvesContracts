const hre = require("hardhat");



///npx hardhat verify --network mainnet 0x858c52bbc608435f035b1913ec0228322ac54c2e 

//npx hardhat run scripts/testnet/deploy.js --network hardhat

const sleep = (milliseconds) => {
  return new Promise(resolve => setTimeout(resolve, milliseconds))
}

async function deployContract(ContractObject) {

  try{
    
    const contractObject = await ContractObject.deploy();
    await contractObject.deployed()
    let txhash = contractObject.deployTransaction.hash
    
    let confirmations = 0

    while (confirmations <= 5) {
      // Waiting expectedBlockTime until the transaction is mined
      const trx = await web3.eth.getTransaction(txhash)
      // Get current block number
      const currentBlock = await web3.eth.getBlockNumber()
      confirmations = trx.blockNumber === null ? 0 : currentBlock - trx.blockNumber
      await sleep(5000)
    }

    await hre.run("verify:verify", { address: contractObject.address }); 

    console.log("deployed and verified: ", contractObject.address)
    return(contractObject)

  }catch(e){
    console.log(e)
  }
  

}

async function deployProxy(ContractObject) {

  const contractObject = await upgrades.deployProxy(ContractObject);
  await contractObject.deployed()
  //await hre.run("verify:verify", { address: contractObject.address }); 
  console.log("deployed proxy: ", contractObject.address)
  await sleep(20000);
  return(contractObject)
}

async function deployContracts() {

  //Deploying on eth
  const MetadataHandler = await ethers.getContractFactory("ElfMetadataHandlerV2");
  const Miren = await ethers.getContractFactory("pMiren");
  const Moon = await ethers.getContractFactory("Moon");
  const Elves = await ethers.getContractFactory("EETestPolygon");
  const Bridge = await ethers.getContractFactory("PrismBridge");
  const Hair = await ethers.getContractFactory("Hair");
  const Race1 = await ethers.getContractFactory("Race1");
  const Race2 = await ethers.getContractFactory("Race2");
  const Weapons1 = await ethers.getContractFactory("Weapons1");
  const Weapons2 = await ethers.getContractFactory("Weapons2");
  const Weapons3 = await ethers.getContractFactory("Weapons3");
  const Weapons4 = await ethers.getContractFactory("Weapons4");
  const Weapons5 = await ethers.getContractFactory("Weapons5");
  const Weapons6 = await ethers.getContractFactory("Weapons6");
  const Accessories = await ethers.getContractFactory("Accessories1");
  const Accessories3 = await ethers.getContractFactory("Accessories3");
  const Accessories4 = await ethers.getContractFactory("Accessories4"); 
  const Accessories5 = await ethers.getContractFactory("Accessories5"); 
  const Accessories6 = await ethers.getContractFactory("Accessories6"); 
  const Accessories7 = await ethers.getContractFactory("Accessories7"); 

  
  const hair = await deployContract(Hair)
  const race1 = await deployContract(Race1)
  const race2 = await deployContract(Race2)
  const weapons1 = await deployContract(Weapons1)
  const weapons2 = await deployContract(Weapons2)
  const weapons3 = await deployContract(Weapons3)
  const weapons4 = await deployContract(Weapons4)
  const weapons5 = await deployContract(Weapons5)
  const weapons6 = await deployContract(Weapons6)
  
  const accessories = await deployContract(Accessories)
  const accessories3 = await deployContract(Accessories3)
  const accessories4 = await deployContract(Accessories4)
  const accessories5 = await deployContract(Accessories5)
  const accessories6 = await deployContract(Accessories6)
  const accessories7 = await deployContract(Accessories7)

  const ren = await deployContract(Miren); 
  const moon = await deployContract(Moon); 
  
  const ethElves = await deployProxy(Elves);
  const inventory = await deployProxy(MetadataHandler);
  const bridge = await deployProxy(Bridge);

}

async function setArt() {
  
const MetadataHandler = await ethers.getContractFactory("ElfMetadataHandlerV2");
const inventory = MetadataHandler.attach("0x5707ff21a520beebccdad13df292576e7fbe4cb4")
console.log("starting")
await inventory.setRace([1,10,11,12,2,3], "0xf2aba59f491942211ca90fa84f95767638f9f307")
await sleep(10000);
await inventory.setRace([4,5,6,7,8,9], "0x2be3e741305458fefeeec27af2f463b068cde71e")
await sleep(10000);
await inventory.setHair([1,2,3,4,5,6,7,8,9], "0x591e02d67db57e698dd6fce73fa01a52da1b1afd")
await sleep(10000);
await inventory.setWeapons([1,10,11,12,13,14,15], "0xf5d650eb960980a983e1cf3fa0c5589f98dbb7da")
await sleep(10000);
console.log("30%")
await inventory.setWeapons([23,24,25,26,27,28,29], "0x18218d5cee6c851fea811a7837452fcb344a5248")
await sleep(10000);
await inventory.setWeapons([38,39,4,40,41,42], "0xe393206bce316db4ca44b78a6db0743e332faafb")//w3
await sleep(10000);
await inventory.setWeapons([16,17,18,19,2,20,21,22], "0x75aa16d3f7b2d4ff559a0e30085e3a2a17ba5763")  
await sleep(10000);
await inventory.setWeapons([3,30,31,32,33,34,35,36,37], "0xb08ffbbcc329b8def4cb9bceaa59977d75053ba3")
await sleep(10000);
await inventory.setWeapons([43,44,45,5,6,7,8,9, 69], "0x610fad0cb149caca388fd1597c7ae852a2de7805")
await sleep(10000);
console.log("50%")
await inventory.setAccessories([15,16,4,5,8,9,1,2,3,6,7,10,11,12,13,14,17,18,19,20,21], "0x5c34c91120b3e95eabf028cf498290c905cbc73d")
await sleep(10000);
await inventory.setAccessories([2,3], "0x1e54f0b7549adf3bb054a8b08b5aaf601b96a18c")
await sleep(10000);
await inventory.setAccessories([10,11,17,18], "0x91a171294bba9052d1f1d7059a46b6708730916a")  
await sleep(10000);
await inventory.setAccessories([6,12,13], "0x6baec3f652262272efaff9982f225a6396099a09")
await sleep(10000);
await inventory.setAccessories([14,19], "0xc382422ba00083c09df4016ff2a8aab9997e1b09")
await sleep(10000);
await inventory.setAccessories([20,21], "0x21a877f20f51a43553828a363caca8464580a7c8")
console.log("done")
}
async function main() {
  
//await deployContracts();
//await setArt();


/*const Elves = await ethers.getContractFactory("EETest");
const elves = Elves.attach("0x45da7f88a52b84ac6f6d52b083fbf3f9f5c26579")
const Bridge = await ethers.getContractFactory("PrismBridge");
const bridge = Bridge.attach("0x20c0799850f2c8d94e2672f2c3178f911272eccd")
*/
//await elves.setInitialAddress("0xed70e87d465b2d87e9bd23b34e7f869885ea9434","0xce5ee326019e9f186cbf0e0738bf0f48148b3192", "0x20c0799850f2c8d94e2672f2c3178f911272eccd", {gasLimit: 100000})
//await bridge.setAddresses("0x45da7f88a52b84ac6f6d52b083fbf3f9f5c26579","0x80861814a8775de20F9506CF41932E95f80f7035", {gasLimit: 100000})
//await elves.flipActiveStatus()
//await sleep(15000)
//await bridge.flipActiveStatus()

//await bridge.checkIn([1], [], 0, 0, "0x2730F644E9C5838D1C8292dB391C0ADE1f65c42d",1, {gasLimit: 100000}) 
  
//REN  0x87353b13c7333d460252aAAFdB775BE01c9724Ae
//MOON 0x37311e190292257cd83f9a9d91750022b396af9d
//ELVES 0x45a48576af2e5aa4ab82dce6fd49a919526b03a5
//BRIDGE 0x1653FeA0EAb46A843239f3993EFFc4Cc0B6706DE
//IM 0x5707ff21a520beebccdad13df292576e7fbe4cb4
  

}


main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
