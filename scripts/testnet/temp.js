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

async function deploySettings() {

  const Miren = await ethers.getContractFactory("pMiren");
  const Moon = await ethers.getContractFactory("Moon");
  const Elves = await ethers.getContractFactory("EETestPolygon");  
  const Wallet = await ethers.getContractFactory("ElvenWallet");
  
  const miren = Miren.attach("0x87353b13c7333d460252aAAFdB775BE01c9724Ae")
  const moon = Moon.attach("0x37311e190292257cd83f9a9d91750022b396af9d")
  const elves = Elves.attach("0x45a48576af2e5aa4ab82dce6fd49a919526b03a5")
  const wallet = Wallet.attach("0x760576ac349439ea3505a6ff668a26ecf61d2224")

 /* console.log("setting minter 1")
  miren.setMinter("0x2730F644E9C5838D1C8292dB391C0ADE1f65c42d", true)
  console.log("done")
  console.log("setting minter 1")
  await sleep(20000);
  moon.setMinter("0x2730F644E9C5838D1C8292dB391C0ADE1f65c42d")
  console.log("minting tokens")
  await sleep(20000);
  miren.mint("0x2730F644E9C5838D1C8292dB391C0ADE1f65c42d", "100000000000000000000000000")
  await sleep(20000);
  moon.mint("0x2730F644E9C5838D1C8292dB391C0ADE1f65c42d", "100000000000000000000000000")
  await sleep(20000);
  console.log("flip wallet")
  wallet.flipActiveStatus();
  await sleep(20000);
  console.log("allow wallet to access elves")
  elves.setAuth(["0x760576ac349439ea3505a6ff668a26ecf61d2224"], true)
  await sleep(20000);*/
  //let result = await wallet.setAddresses("0x45a48576af2e5aa4ab82dce6fd49a919526b03a5", "0x87353b13c7333d460252aAAFdB775BE01c9724Ae", "0x37311e190292257cd83f9a9d91750022b396af9d", "0x37311e190292257cd83f9a9d91750022b396af9d")
  
  await wallet.approve(1);

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
  await deploySettings();


}


main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
