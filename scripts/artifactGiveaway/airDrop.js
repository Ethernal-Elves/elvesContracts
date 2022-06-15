
const hre = require("hardhat");
const {wallets} = require("./batchOne.json")


const sleep = (milliseconds) => {
    return new Promise(resolve => setTimeout(resolve, milliseconds))
  }


async function main() {    

      const ElvesPoly = await ethers.getContractFactory("Artifacts");
      const elves = ElvesPoly.attach("0xdb2e506d2863646c0141f77f2ce9f99bbbb6b8ab")    

      let arrayLength = wallets.length;
     
 
      for (let i = 0; i < arrayLength; i++) {
        
       
        let to = wallets[i].wallet
        let amount = wallets[i].count

        try{
          let result = await elves.safeTransferFrom("0xe7AF77629e7ECEd41C7B7490Ca9C4788F7c385E5", to,1,amount,0000000000000000000000000000000000000000000000000000000000000000,{gasLimit: 1000000});
          console.log("resultHash: ", result.hash, "current set:", i, " to: ", to,  " amt:", amount)
        }catch(e){
            console.log(e)
            console.log("This set failed: ", i)
            await sleep(30000)
            let result = await elves.safeTransferFrom("0xe7AF77629e7ECEd41C7B7490Ca9C4788F7c385E5", to,1,amount,0000000000000000000000000000000000000000000000000000000000000000, {gasLimit: 1000000});
            console.log("resultHash: ", result.hash, "current set:", i, " to: ", to,  " amt:", amount)
        }    
        
        await sleep(30000)
        
      }
    
      console.log("done")
    }





main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
