const hre = require("hardhat");


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

async function deployContracts() {

  const Artifacts = await ethers.getContractFactory("Artifacts");
  const contractObject = await upgrades.deployProxy(Artifacts);

 console.log("deployed Artifacts")

}


async function main() {
    await deployContracts()
    console.log("done")
}


main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
