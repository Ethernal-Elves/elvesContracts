
const hre = require("hardhat");
const {batch} = require("./set2.json")


const sleep = (milliseconds) => {
    return new Promise(resolve => setTimeout(resolve, milliseconds))
  }


async function main() {    

      const ElvesPoly = await ethers.getContractFactory("EldersInventoryManager");
      const elves = ElvesPoly.attach("0x3785cb370a473a186b79efd9ea49e5f638715206")    
      const folder = "QmaZWCya3E82rTUAi9vURmPu8Rermuo7ghUGxPCYgG3A76"

      let arrayLength = batch.length;

       //split the array of objects batch into chunks of size 5
       const newIdArray = []
       const newNameArray = []
            for (let i = 0; i < arrayLength; i ++) {
                newIdArray.push(batch[i].identifier)
                newNameArray.push(batch[i].name)
            }

            const newIdArrayChunks = []
            const newNameArrayChunks = []
            for (let i = 0; i < arrayLength; i += 5) {
                newIdArrayChunks.push(newIdArray.slice(i, i + 5))
                newNameArrayChunks.push(newNameArray.slice(i, i + 5))
            }

            //console.log(newIdArrayChunks)
            //console.log(newNameArrayChunks)
            

  for (let i = 0; i < newIdArrayChunks.length; i++) {
    let ids = newIdArrayChunks[i]
    let names = newNameArrayChunks[i]
        try{
         

          let result = await elves.addItem(ids,names,folder, {gasLimit: 1000000});
          console.log("resultHash: ", result.hash, "current set:", i)
        }catch(e){
            console.log(e)
            console.log("This set failed: ", i)
            await sleep(30000)
            let result = await elves.addItem(ids,names,folder, {gasLimit: 1000000});
          console.log("resultHash: ", result.hash, "current set:", i)
        }    
        
        await sleep(45000)
        
      }
    
      console.log("done")
    }





main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
