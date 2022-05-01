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

  console.log("Deploying artifacts")
  //Deploying on eth
  const Artifacts = await ethers.getContractFactory("ElvesArtifacts");
  const ArtifactArt1 = await ethers.getContractFactory("ArtifactArt1"); 
  console.log("Deploying art")
  const artifactArt1 = await deployContract(ArtifactArt1)
//  await sleep(20000)
//  const artifacts = deployProxy(Artifacts); 
//  await sleep(20000)
//  console.log("Setting Art")
//  await artifacts.setArt([1], "0xA42E7535B6c062a62E361EF834Da29448AF18B83") 
  console.log("Done")

}


deployContracts()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
