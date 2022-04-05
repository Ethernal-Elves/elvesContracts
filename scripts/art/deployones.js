const hre = require("hardhat");

//POLY let imAddress = "0x3cF1630393BFd1D9fF52bD822fE88714FC81467E"

//ETH 

let imAddress = "0x04ff3733a737ffE5f79D0B8F29EAD0E31d512ffD"

const sleep = (milliseconds) => {
  return new Promise(resolve => setTimeout(resolve, milliseconds))
}


async function deployArt() {

  const Accessories5 = await ethers.getContractFactory("Accessories5");
  const Accessories6 = await ethers.getContractFactory("Accessories6");
  const Accessories7 = await ethers.getContractFactory("Accessories7");
  
  
  ///Deploy art contracts
    console.log("deploying art contract")

    //const accessories5 = await Accessories5.deploy();
    //const accessories6 = await Accessories6.deploy();
    //const accessories7 = await Accessories7.deploy();
    console.log("deployed art contracts")
    await sleep(1000)
    console.log("waiting for 60 seconds, then will add them to the inventory manager")
   
    //await sleep(60000)
    //Deploying the contracts
    console.log("attaching inventory manager")  
    const MetadataHandler = await ethers.getContractFactory("ElfMetadataHandlerV2");

    const inventory = MetadataHandler.attach(imAddress)
    console.log("setting up inventory manager with new art")      

    await inventory.setAccessories([6,12,13], "0x1ba1edaaeb4eec76fcced0b832ff35b5320473b7")
    await inventory.setAccessories([14,19], "0x1efb57ce9d37cfa2916755bc5e8fad53713c0d4c")
    await inventory.setAccessories([20,21], "0xc68862f2c67df86b53e7abe4bd079ef68984611b")

 
}



async function main() {
    
  

  const inventory = await deployArt()


 
  console.log("done")


  
}


main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
