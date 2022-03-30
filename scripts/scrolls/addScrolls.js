
const hre = require("hardhat");
const polyElvesAbi =  require("../../artifacts/contracts/Polygon/EthernalElvesPolyL2v4.sol/PolyEthernalElvesV4.json");
const {wallets} = require("./wallets.json")


const sleep = (milliseconds) => {
    return new Promise(resolve => setTimeout(resolve, milliseconds))
  }


async function main() {
    
 
    const iface = new ethers.utils.Interface(polyElvesAbi.abi)

      const ElvesPoly = await ethers.getContractFactory("PolyEthernalElvesV4");
      const elves = ElvesPoly.attach("0x4deab743f79b582c9b1d46b4af61a69477185dd5")    

      let arrayLength = wallets.length;
      let sets = Math.ceil(arrayLength / 25);
      let start = 0;
      let end = 25;
 
      for (let i = 0; i < sets; i++) {
        let subWallets = wallets.slice(start, end);
       
        let subWalletsAddresses = subWallets.map(x => x.wallet);
        let subWalletsScrolls = subWallets.map(x => x.scrolls);

        try{
          let result = await elves.addScolls(subWalletsScrolls, subWalletsAddresses, {gasLimit: 1000000});
          console.log("resultHash: ", result.hash, "current set:", i)
        }catch(e){
            console.log(e)
            console.log("This set failed: ", i)
            sleep(15000)
            let result = await elves.addScolls(subWalletsScrolls, subWalletsAddresses, {gasLimit: 1000000});
            console.log("resultHash: ", result.hash, "current set:", i)
        }

        start = end;
        end = end + 25;        
        
        sleep(15000)
      }

      console.log("total items: ", arrayLength)
      console.log("total sets: ", sets)
      



}


main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
