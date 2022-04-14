const hre = require("hardhat");



///npx hardhat verify --network rinkeby 0x858c52bbc608435f035b1913ec0228322ac54c2e 

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
  const Miren = await ethers.getContractFactory("Miren");
  const Elves = await ethers.getContractFactory("EETest");
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
  
  const ethElves = await deployProxy(Elves);
  const inventory = await deployProxy(MetadataHandler);
  const bridge = await deployProxy(Bridge);

}

async function setArt() {
  
const MetadataHandler = await ethers.getContractFactory("ElfMetadataHandlerV2");
const inventory = MetadataHandler.attach("0xed70e87d465b2d87e9bd23b34e7f869885ea9434")
console.log("starting")
await inventory.setRace([1,10,11,12,2,3], "0x66e4FB86Ca426dF1F3e5892eb8d0a229E4408154")
await sleep(10000);
await inventory.setRace([4,5,6,7,8,9], "0x33767c4a85B1C9B143ee53d4E21dA1CB67310071")
await sleep(10000);
await inventory.setHair([1,2,3,4,5,6,7,8,9], "0x2DB7510824c9B24520170ac1BeFbcf1E5ab4aB9C")
await sleep(10000);
await inventory.setWeapons([1,10,11,12,13,14,15], "0xF9920C5ad0966d533868826eFD9E928b2876cB7B")
await sleep(10000);
console.log("30%")
await inventory.setWeapons([23,24,25,26,27,28,29], "0xafee685bc07241df9e7a864ea46ac418bdbbc362")
await sleep(10000);
await inventory.setWeapons([38,39,4,40,41,42], "0x32982ce19a7c06ec988cfa9b9438a9631f46e80b")
await sleep(10000);
await inventory.setWeapons([16,17,18,19,2,20,21,22], "0x3c5095124442b843c45ca4c693be24660293f350")  
await sleep(10000);
await inventory.setWeapons([3,30,31,32,33,34,35,36,37], "0x82569162deae886216a03f8186e74d7048292640")
await sleep(10000);
await inventory.setWeapons([43,44,45,5,6,7,8,9, 69], "0x8aa36f985c9722b2faf17f93d4ffe656e1b9dd5f")
await sleep(10000);
console.log("50%")
await inventory.setAccessories([15,16,4,5,8,9,1,2,3,6,7,10,11,12,13,14,17,18,19,20,21], "0xc210e4e4a3fe7e8655826ec9c5391fb74f88f9de")
await sleep(10000);
await inventory.setAccessories([2,3], "0x04295d438cfa8a859d78a6b6162f76652194c605")
await sleep(10000);
await inventory.setAccessories([10,11,17,18], "0x64cabdec14caada99e1d82c6a6eb026b014ea840")  
await sleep(10000);
await inventory.setAccessories([6,12,13], "0xec5fb86f30c9e9efea62e2700c1bc85cb9c2c6ee")
await sleep(10000);
await inventory.setAccessories([14,19], "0xa01b39c23cf893930abd296ce7170901ceeef1a1")
await sleep(10000);
await inventory.setAccessories([20,21], "0xcb1b4215f9b7942bf6baf08087a387417c9982a3")
console.log("done")
}
async function main() {
  
//await deployContracts();
//await setArt();


const Elves = await ethers.getContractFactory("EETest");
const elves = Elves.attach("0x45da7f88a52b84ac6f6d52b083fbf3f9f5c26579")
const Bridge = await ethers.getContractFactory("PrismBridge");
const bridge = Bridge.attach("0x20c0799850f2c8d94e2672f2c3178f911272eccd")

//await elves.setInitialAddress("0xed70e87d465b2d87e9bd23b34e7f869885ea9434","0xce5ee326019e9f186cbf0e0738bf0f48148b3192", "0x20c0799850f2c8d94e2672f2c3178f911272eccd", {gasLimit: 100000})
//await bridge.setAddresses("0x45da7f88a52b84ac6f6d52b083fbf3f9f5c26579","0x80861814a8775de20F9506CF41932E95f80f7035", {gasLimit: 100000})
//await elves.flipActiveStatus()
//await sleep(15000)
//await bridge.flipActiveStatus()

await bridge.checkIn([1], [], 0, 0, "0x2730F644E9C5838D1C8292dB391C0ADE1f65c42d",1, {gasLimit: 100000}) 
  
  

  
}


main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
