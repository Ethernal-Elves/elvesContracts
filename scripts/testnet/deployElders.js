const hre = require("hardhat");



///npx hardhat verify --network mainnet 0x858c52bbc608435f035b1913ec0228322ac54c2e 

//npx hardhat run scripts/testnet/deployElders.js --network rinkeby

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

  console.log("Deploying Elders")
  //Deploying on eth
  const Elders = await ethers.getContractFactory("Elders");
  const elders = await deployProxy(Elders); 

  const EldersInventoryManager = await ethers.getContractFactory("EldersInventoryManager");
  const eldersInventoryManager = await deployProxy(EldersInventoryManager);

  console.log("Done")

  //npx hardhat run scripts/testnet/deployElders.js --network rinkeby
  //npx hardhat verify --network rinkeby 0x0d002fEF931d2204816EaaF0AaA75CD1D5BAe971 

}


deployContracts()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
