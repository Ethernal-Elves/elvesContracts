const hre = require("hardhat");

let walletAddress = "0x87e8fbe53fa6c1900bcb8511124c65467e0e71bb"

const sleep = (milliseconds) => {
  return new Promise(resolve => setTimeout(resolve, milliseconds))
}


async function setUp() {


    const Wallet = await ethers.getContractFactory("ElvenWallet");

    const wallet = Wallet.attach(walletAddress)
    
  //  let authResult = await wallet.setAuth(["0xe4fbf2b9442c541299b2f01577a32fef002f42f7","0xe2223685cd3cbbed5c823ac9f21268a61e9a3789"], 1)
   // sleep(10000)
  //  let lpResult = await wallet.setMoonForLP("1200000000000000000000000")

    await wallet.setAddresses("0x4deab743f79b582c9b1d46b4af61a69477185dd5", "0xA2eCFEBe618E90608882c4aD6b3a2eA6FdEB5e46", "0x6C183674Cf5948508f1ABb75c4AF2CAA0b1a9d81",  
                                "0x036b85e1f14c7e5cf9e80b6dc51bccda38c09242")

  
}



async function main() {
    
  

  const inventory = await setUp()


 
  console.log("done")


  
}


main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
