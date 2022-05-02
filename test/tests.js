const fs = require('fs-extra')
const path = require('path')

const { expect } = require("chai");
const { ethers, waffle } = require("hardhat");
const {initEthers, assertThrowsMessage, signPackedData, getTimestamp, increaseBlockTimestampBy} = require('./helpers')


const increaseWorldTimeinSeconds = async (seconds, mine = false) => {
  await ethers.provider.send("evm_increaseTime", [seconds]);
  if (mine) {
    await ethers.provider.send("evm_mine", []);
  }
};

const validator = "0x80861814a8775de20F9506CF41932E95f80f7035"


describe("Ethernal Elves Contracts", function () {
  let owner;
  let beff;
  let addr3;
  let addr4;
  let addr5;
  let addrs;
  let ren
  let pRen
  let ethElves
  let inventory
  let campaigns
  let eBridge
  let pBridge
  let artifacts
  let moon
  let dao
  let slp 
  let wallet
  let elders
  let eldersInventory


  // `beforeEach` will run before each test, re-deploying the contract every
  // time. It receives a callback, which can be async.
  beforeEach(async function () {
  // Get the ContractFactory and Signers here.
  // Deploy each contract and Initialize main contract with varialbes 
    
  [owner, beff, addr3, addr4, addr5, ...addrs] = await ethers.getSigners();
  
  //owner and beff are dev wallets. addr3 and addr4 will be used to test the game and transfer/banking functions
  
  const MetadataHandler = await ethers.getContractFactory("ElfMetadataHandlerV2");
  const Miren = await ethers.getContractFactory("Miren");
  const Pmiren = await ethers.getContractFactory("pMiren");
  const Moon = await ethers.getContractFactory("Moon");
  const SLP = await ethers.getContractFactory("SLP");
  const Wallet = await ethers.getContractFactory("ElvenWallet");
  const Elves = await ethers.getContractFactory("EETest");
  const Pelves = await ethers.getContractFactory("EETestPolygon");
  const Campaigns = await ethers.getContractFactory("ElfCampaignsV3");
  const Artifacts = await ethers.getContractFactory("Artifacts");
  const Bridge = await ethers.getContractFactory("PrismBridge");
  //const ElvenDao = await ethers.getContractFactory("ElvenDao");
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

  const ArtifactArt1 = await ethers.getContractFactory("ArtifactArt1"); 
  const Elders = await ethers.getContractFactory("Elders");
  //const ArtifactArt2 = await ethers.getContractFactory("ArtifactArt2"); 
  //const ArtifactArt3 = await ethers.getContractFactory("ArtifactArt3"); 

  const hair = await Hair.deploy();
  const race1 = await Race1.deploy();
  const race2 = await Race2.deploy();
  const weapons1 = await Weapons1.deploy();
  const weapons2 = await Weapons2.deploy();
  const weapons3 = await Weapons3.deploy();
  const weapons4 = await Weapons4.deploy();
  const weapons5 = await Weapons5.deploy();
  const weapons6 = await Weapons6.deploy();
  const accessories = await Accessories.deploy();
  const accessories3 = await Accessories3.deploy();
  const accessories4 = await Accessories4.deploy();
  const accessories5 = await Accessories5.deploy();
  const accessories6 = await Accessories6.deploy();
  const accessories7 = await Accessories7.deploy();

  const artifactArt1 = await ArtifactArt1.deploy();
  //const artifactArt2 = await ArtifactArt2.deploy();
  //const artifactArt3 = await ArtifactArt3.deploy();
  
  artifacts = await upgrades.deployProxy(Artifacts); 
  await artifacts.setArt(artifactArt1.address)
  //await artifacts.setArt([4,5], artifactArt2.address)
  //await artifacts.setArt([7,8,9], artifactArt3.address)

  ren = await Miren.deploy(); 
  pRen = await Pmiren.deploy(); 
  moon = await Moon.deploy();
  wallet = await upgrades.deployProxy(Wallet);

  slp = await SLP.deploy();
  moon.deployed()
  
  
  eBridge = await upgrades.deployProxy(Bridge);
  pBridge = await upgrades.deployProxy(Bridge);
  //dao = ElvenDao.deploy(moon.address);
  

  ethElves = await upgrades.deployProxy(Elves);
  elvesPolygon = await upgrades.deployProxy(Pelves);   
  elders = await await upgrades.deployProxy(Elders); 
  
  await artifacts.setAuth([elders.address], true);
  
  inventory = await upgrades.deployProxy(MetadataHandler);

  await elvesPolygon.deployed();
  await ethElves.deployed();  
  campaigns = await upgrades.deployProxy(Campaigns, [ethElves.address]);
  await campaigns.deployed();
  await campaigns.newCamps();

  await elvesPolygon.setAddresses(inventory.address, "0x80861814a8775de20F9506CF41932E95f80f7035");


  await inventory.setRace([1,10,11,12,2,3], race1.address)
  await inventory.setRace([4,5,6,7,8,9], race2.address)  
  await inventory.setHair([1,2,3,4,5,6,7,8,9], hair.address)
  await inventory.setWeapons([1,10,11,12,13,14,15], weapons1.address)
  await inventory.setWeapons([23,24,25,26,27,28,29], weapons2.address)
  await inventory.setWeapons([38,39,4,40,41,42], weapons3.address)
  await inventory.setWeapons([16,17,18,19,2,20,21,22], weapons4.address)  
  await inventory.setWeapons([3,30,31,32,33,34,35,36,37], weapons5.address)
  await inventory.setWeapons([43,44,45,5,6,7,8,9, 69], weapons6.address)
  await inventory.setAccessories([15,16,4,5,8,9,1,2,3,6,7,10,11,12,13,14,17,18,19,20,21], accessories.address)
  await inventory.setAccessories([2,3], accessories3.address)
  await inventory.setAccessories([10,11,17,18], accessories4.address)  
  await inventory.setAccessories([6,12,13], accessories5.address)
  await inventory.setAccessories([14,19], accessories6.address)
  await inventory.setAccessories([20,21], accessories7.address)
     
 
  await ren.setMinter(ethElves.address, 1)  
  await ren.setMinter(owner.address, 1)
  await moon.setMinter(elvesPolygon.address)
  await moon.setMinter(owner.address)
  await pRen.setMinter(elvesPolygon.address, 1)  
  await pRen.setMinter(wallet.address, 1) 
  await pRen.setMinter(owner.address, 1)
  await slp.setMinter(owner.address, 1)

  await wallet.setAddresses(elvesPolygon.address, pRen.address, moon.address, slp.address)
  await wallet.setAuth([addr3.address,addr4.address,addr5.address],true)
  await wallet.setMoonForLP("1400000000000000000000000")

  await elvesPolygon.setAuth([owner.address, addr3.address, pBridge.address], true);

  await ethElves.flipActiveStatus();
  await eBridge.setAddresses(ethElves.address, validator);
  await pBridge.setAddresses(elvesPolygon.address, validator);

  await ethElves.setBridge(eBridge.address)
  await ethElves.setInitialAddress(ren.address, inventory.address, eBridge.address)
  
  await elders.setAddresses(artifacts.address, inventory.address)
  await elvesPolygon.setCreatureHealth("420");
  
  //mint some elves 
        let level = [1,77,100,99,100,60,45]
        let sentineClass = [0,1,2]
        let race = [0,1,2,3]
        let axa = [0,1,2,3,4,5,6]
        let item = [0,1,2,3,4,5,6]
        let weapon = [1,2,3,4,5,6,7,8,9,10,11,12,13,14]
        let weaponTier = [1,2,3,4,5]

       //MINT TEST ELVES ON POLYGON
          await elvesPolygon.connect(addr3).mint(level[0],axa[0],race[0],sentineClass[1], item[3], weapon[0], weaponTier[3]);
          await elvesPolygon.connect(addr3).mint(level[1],axa[0],race[0],sentineClass[2], item[2], weapon[0], weaponTier[2]);
          await elvesPolygon.connect(addr3).mint(level[2],axa[1],race[0],sentineClass[0], item[6], weapon[0], weaponTier[4]);
          
          await elvesPolygon.connect(addr4).mint(10,1,1,1,0,1,1);
          await elvesPolygon.connect(addr4).mint(10,1,1,0,0,1,1); //DRUID
          //one for ones
          await elvesPolygon.connect(addr3).mint(level[2],axa[5],race[0],sentineClass[0], item[3], weapon[12], weaponTier[4]);
          await elvesPolygon.connect(addr3).mint(level[2],axa[4],race[0],sentineClass[1], item[2], weapon[12], weaponTier[4]);
          await elvesPolygon.connect(addr3).mint(level[2],axa[4],race[0],sentineClass[2], item[4], weapon[12], weaponTier[4]);   
          //FOr Transfers
          await elvesPolygon.connect(addr3).mint(level[0],axa[0],race[0],sentineClass[1], item[3], weapon[0], weaponTier[0]);
          await elvesPolygon.connect(addr3).mint(level[1],axa[0],race[0],sentineClass[2], item[2], weapon[0], weaponTier[0]);
          await elvesPolygon.connect(addr3).mint(level[2],axa[1],race[0],sentineClass[0], item[6], weapon[0], weaponTier[0]);       
        
        //MIN TEST ELVES ON ETH
          await ethElves.connect(addr3).mint(level[0],axa[0],race[0],sentineClass[1], item[3], weapon[0], weaponTier[0]);
          await ethElves.connect(addr3).mint(level[1],axa[0],race[0],sentineClass[2], item[2], weapon[0], weaponTier[0]);
          await ethElves.connect(addr3).mint(level[2],axa[1],race[0],sentineClass[0], item[6], weapon[0], weaponTier[0]);
        
        
        
        
        await elvesPolygon.addRampage(4,5,30,65, 0, 1, 100,0,100)
        await elvesPolygon.addRampage(3,5,30,65, 0, 1, 100,600,100)
      
        let fundRen = "100000000000000000000000"
        let slpFund = "400000000000000000000000"
        await elvesPolygon.adminSetAccountBalance(addr3.address, fundRen)
        await ren.mint(addr3.address, fundRen)

        await slp.mint(addr3.address, slpFund)
        await slp.mint(addr4.address, slpFund)
        await slp.mint(addr5.address, slpFund)
        await moon.mint(wallet.address, "1400000000000000000000000")
      
        await elvesPolygon.addScrolls([10, 2], [addr3.address, addr4.address])
        await elvesPolygon.addArtifacts([10, 2], [addr3.address, addr4.address])        
        
  
  });

  describe("Elders", function () {

    it("Mint Elders for Artifacts", async function () {
      await artifacts.reserve(14);
      await elders.mint(2);

    })

  });

  describe("LP Stuff", function () {

    it("EXCHANGE SLP FOR TOKENS", async function () {


      await slp.connect(addr3).approve(wallet.address,"10000000000000000000000000000000000000000")
      await slp.connect(addr4).approve(wallet.address,"10000000000000000000000000000000000000000")
      await slp.connect(addr5).approve(wallet.address,"10000000000000000000000000000000000000000")

      let remainTokens = 1400000000
      let count = 0

      while(remainTokens > 1000000){
      await wallet.connect(addr3).exchangeSLPForMoon(addr3.address, "25000000000000000000")//25
      await wallet.connect(addr4).exchangeSLPForMoon(addr4.address, "35000000000000000000")//23
      await wallet.connect(addr5).exchangeSLPForMoon(addr5.address, "50000000000000000000")//50
      count = count + 3  
      remainTokens = parseInt(await wallet.moonForLPsLeft()/1000000000000000000)  
     
    }
    console.log("total txs:", count)
    console.log("SLP BALANCE: ", parseInt(await slp.balanceOf(wallet.address))/1000000000000000000)
    console.log("MOON FOR LPS REMAIN: ", parseInt(await wallet.moonForLPsLeft()/1000000000000000000), "SLP SWAPRATE: " , parseInt(await wallet.getSlpSwapRate()))
      
    })

  })

 
  it("Mint Artifacts", async function () {

    //await artifacts.mint(10, 1600, "0x93b53bfab6b02ccb4212ede5fecba3545a0643d6406f617cde50f3cae453d361549b2db31285f82d307ac6e28177dd3ea9cb6c16d7e8aef64e566e44db0bdc871b");
    await artifacts.reserve(10);
    //console.log(await artifacts.uri(1337))       
    console.log(await artifacts.balanceOf(owner.address, 1))       

    await artifacts.burn(owner.address, 1, 2);
    console.log("//BREAKER//")       
    console.log(await artifacts.balanceOf(owner.address, 1))       
    //console.log(await artifacts.tokenURI(1))       
   

   })

   it("Add scrolls, go on crusade", async function () {

    
     expect(parseInt(await elvesPolygon.scrolls(addr3.address))).to.equal(10)

   

     await elvesPolygon.connect(addr3).sendCrusade([1],addr3.address, false);
     await elvesPolygon.connect(addr3).sendCrusade([2],addr3.address, false);
     await elvesPolygon.connect(addr3).sendCrusade([3],addr3.address, false);

     expect(parseInt(await elvesPolygon.scrolls(addr3.address))).to.equal(10-3)
     
     console.log("ts1:", await elvesPolygon.elves(1))
     console.log("ts2:", await elvesPolygon.elves(2))
     console.log("ts3:", await elvesPolygon.elves(3))
     //await elvesPolygon.connect(addr3).heal(3,1, addr3.address);

    
     increaseWorldTimeinSeconds(10 * 24* 24 * 60 * 60, true)
     await elvesPolygon.connect(addr3).returnCrusade([1],addr3.address, false);
     await elvesPolygon.connect(addr3).returnCrusade([2],addr3.address, false);
     await elvesPolygon.connect(addr3).returnCrusade([3],addr3.address, false);

         
     console.log("Artifacts got", parseInt(await elvesPolygon.artifacts(addr3.address)))
    
     

    })


    
   it("Test REN costs for each function", async function () {

    

     await elvesPolygon.adminSetAccountBalance(addr4.address, ethers.utils.parseEther("200"))

     await elvesPolygon.connect(owner).forging([4], addr4.address)
     increaseWorldTimeinSeconds(10 * 24* 24 * 60 * 60, true)

     await elvesPolygon.adminSetAccountBalance(addr4.address, ethers.utils.parseEther("10"))

     await elvesPolygon.connect(owner).merchant([4], addr4.address)
     increaseWorldTimeinSeconds(10 * 24* 24 * 60 * 60, true)

     let tryAxa = true
     let useItem = true
     let tryWeapon = true
     let rampage = 3

     await elvesPolygon.adminSetAccountBalance(addr4.address, ethers.utils.parseEther("600"))
     
     await elvesPolygon.connect(owner).rampage([4],rampage,tryWeapon, tryAxa, useItem,addr4.address);

     await elvesPolygon.connect(owner).heal([5],[4], addr4.address);

     await elvesPolygon.adminSetAccountBalance(addr4.address, ethers.utils.parseEther("5"))

     await elvesPolygon.connect(owner).synergize([5], addr4.address);

     increaseWorldTimeinSeconds(10 * 24* 24 * 60 * 60, true)

     await elvesPolygon.adminSetAccountBalance(addr4.address, ethers.utils.parseEther("1500"))
     await elvesPolygon.connect(owner).sendCrusade([4], addr4.address, false)
    
     expect(parseInt(await elvesPolygon.bankBalances(addr4.address))).to.equal(0)
    })    



    describe("New Features", function () {

      it("Passive Mode on Polygon", async function () {

        increaseWorldTimeinSeconds(10 * 24* 24 * 60 * 60, true)
        await elvesPolygon.connect(addr3).passive([1],addr3.address);
        await elvesPolygon.connect(addr3).passive([2],addr3.address);
        await elvesPolygon.connect(addr3).passive([3],addr3.address);
        increaseWorldTimeinSeconds( 9 * 24 * 60 * 60, true)
        await elvesPolygon.connect(addr3).returnPassive([1],addr3.address);
        await elvesPolygon.connect(addr3).returnPassive([2],addr3.address);
        await elvesPolygon.connect(addr3).returnPassive([3],addr3.address);

    
       })

      it("CHECK IN BRIDGE ETH", async function () {
        await eBridge.connect(addr3).checkIn([1,2,3],[],0,10000000,addr3.address,1)
       // await eBridge.connect(addr3).checkIn([1,2,3],[],0,10000000,addr3.address,1)
         
  
         
      })

      it("CHECK IN BRIDGE POLYGON", async function () {
       
        await pBridge.connect(addr3).checkIn([9,10,11],[],0,10000000,addr3.address,1)     
      //  await pBridge.connect(addr3).checkIn([9,10,11],[],0,10000000,addr3.address,1)     
  
         
      })

      it("Rampage, Heal and Bloodthirst tests", async function () {


           
        let tryAxa = true
        let useItem = true
        let tryWeapon = true
        let rampage = 4
       console.log("RAMPAGE")
        await elvesPolygon.connect(addr3).rampage([1],rampage,tryWeapon, tryAxa, useItem,addr3.address);
        //increaseWorldTimeinSeconds(36* 24 * 60 * 60, true)
        console.log("BLOODTHIRST")
        console.log("CREATURE HEALTH: ", await elvesPolygon.CREATURE_HEALTH())

        await elvesPolygon.connect(addr3).bloodThirst([2], tryAxa, useItem,addr3.address);
        console.log("HEAL")
        await elvesPolygon.connect(addr3).heal([3],[1],addr3.address);
        console.log("BLOODTHIRST 1/1s") 
       
        await elvesPolygon.connect(owner).bloodThirst([6,7,8], false, false, addr3.address)       
        increaseWorldTimeinSeconds(10000000000, true)
        for(let i =0; i<100; i++){
        await elvesPolygon.connect(owner).bloodThirst([7], false, false, addr3.address)
        increaseWorldTimeinSeconds(10000000000, true)       
        }
        
  //     console.log(await elvesPolygon.attributes(1))
  //     console.log(await elvesPolygon.elves(1))
  //     console.log(await elvesPolygon.rampages(rampage))
  //     console.log(await elvesPolygon.bankBalances(addr3.address))
 
  
     })
  
    })

       

    })


    




    /*

   

    it("Inventory tests", async function () {

     
       for(let i =0; i<2; i++){
       
        await elvesPolygon.connect(addr3).merchant([1], addr3.address);
        //increaseWorldTimeinSeconds(100, true)
        //await elvesPolygon.connect(addr3).bloodThirst([1], true, false, addr3.address)
        //increaseWorldTimeinSeconds(10000000, true)
        //await elvesPolygon.rampage([1],rampage,tryWeapon, tryAxa, useItem,addr3.address);
       
       }
      
       //elvesPolygon.connect(addr3).forging([1],{ value: ethers.utils.parseEther("0.0")});    
     

       

    })

    it("Trade Items tests", async function () {

      elvesPolygon.addPawnItem(1,10,15,10,9)
      elvesPolygon.addPawnItem(2,20,25,10,3)
      elvesPolygon.addPawnItem(3,30,35,10,3)
      elvesPolygon.addPawnItem(4,40,45,10,0)
      elvesPolygon.addPawnItem(5,50,55,10,5)

        await elvesPolygon.connect(addr3).sellItem(1, addr3.address) 

        await elvesPolygon.connect(addr3).buyItem(1,5, addr3.address) 
    

        /*console.log(await elvesPolygon.pawnItems(1))
        console.log(await elvesPolygon.pawnItems(2))
        console.log(await elvesPolygon.pawnItems(3))
        console.log(await elvesPolygon.pawnItems(4))
        console.log(await elvesPolygon.pawnItems(5))
      */

       // expect(await token.balanceOf(wallet.address)).to.equal(993);

      
       //elvesPolygon.connect(addr3).forging([1],{ value: ethers.utils.parseEther("0.0")});   

 /* describe("Check In, Check Out", function () {
    it("Stake Sentinels with Contract", async function () {

      await elvesPolygon.connect(addr3).mint({ value: ethers.utils.parseEther(mintPrice)});
      await elvesPolygon.connect(addr3).mint({ value: ethers.utils.parseEther(mintPrice)});
      await elvesPolygon.connect(addr3).mint({ value: ethers.utils.parseEther(mintPrice)});

      await ren.mint(addr3.address, ethers.BigNumber.from("90000000000000000000000")); 

      console.log(await elvesPolygon.ownerOf(1))
    

      await elvesPolygon.connect(addr3).checkIn([1,2,3], "90000000000000000000000");

       console.log(await elvesPolygon.ownerOf(1))


      //check out

   //   let sentinelDNA = "45427413644928360261459227712385514627098612091526571146141633128741054971904"
// console.log(await elvesPolygon.getSentinel(2))
   //   await elvesPolygon.connect(addr3).checkOut(1, sentinelDNA)


    })

  });

  */

 /*  describe("Test Re-roll", function () {
      it("Reroll probabailities", async function () {

      await elvesPolygon.connect(addr3).mint({ value: ethers.utils.parseEther(mintPrice)});
      await elvesPolygon.connect(addr3).mint({ value: ethers.utils.parseEther(mintPrice)});
      await elvesPolygon.connect(addr3).mint({ value: ethers.utils.parseEther(mintPrice)});
      await elvesPolygon.connect(addr3).mint({ value: ethers.utils.parseEther(mintPrice)});
      await elvesPolygon.connect(addr3).mint({ value: ethers.utils.parseEther(mintPrice)});
      await elvesPolygon.connect(addr3).mint({ value: ethers.utils.parseEther(mintPrice)});
      await elvesPolygon.connect(addr3).mint({ value: ethers.utils.parseEther(mintPrice)});
      await elvesPolygon.connect(addr3).mint({ value: ethers.utils.parseEther(mintPrice)});
      await elvesPolygon.connect(addr3).mint({ value: ethers.utils.parseEther(mintPrice)});
      await elvesPolygon.connect(addr3).mint({ value: ethers.utils.parseEther(mintPrice)});
      await elvesPolygon.connect(addr3).mint({ value: ethers.utils.parseEther(mintPrice)});
      await elvesPolygon.connect(addr3).mint({ value: ethers.utils.parseEther(mintPrice)});
      await elvesPolygon.connect(addr3).mint({ value: ethers.utils.parseEther(mintPrice)});
      await elvesPolygon.connect(addr3).mint({ value: ethers.utils.parseEther(mintPrice)});
      await elvesPolygon.connect(addr3).mint({ value: ethers.utils.parseEther(mintPrice)});
      await elvesPolygon.connect(addr3).mint({ value: ethers.utils.parseEther(mintPrice)});
      await elvesPolygon.connect(addr3).mint({ value: ethers.utils.parseEther(mintPrice)});
      await elvesPolygon.connect(addr3).mint({ value: ethers.utils.parseEther(mintPrice)});
      await elvesPolygon.connect(addr3).mint({ value: ethers.utils.parseEther(mintPrice)});
      await elvesPolygon.connect(addr3).mint({ value: ethers.utils.parseEther(mintPrice)});


      await elvesPolygon.connect(addr4).mint({ value: ethers.utils.parseEther(mintPrice)});
      await elvesPolygon.connect(addr4).mint({ value: ethers.utils.parseEther(mintPrice)});
      await elvesPolygon.connect(addr5).mint({ value: ethers.utils.parseEther(mintPrice)});
      await elvesPolygon.connect(addr5).mint({ value: ethers.utils.parseEther(mintPrice)});

      await elvesPolygon.connect(addr3).merchant([1], {value: ethers.utils.parseEther("0.01")})
      await elvesPolygon.connect(addr3).merchant([2], {value: ethers.utils.parseEther("0.01")})
      await elvesPolygon.connect(addr3).merchant([3], {value: ethers.utils.parseEther("0.01")})
      await elvesPolygon.connect(addr3).merchant([4], {value: ethers.utils.parseEther("0.01")})
      await elvesPolygon.connect(addr3).merchant([5], {value: ethers.utils.parseEther("0.01")})
      await elvesPolygon.connect(addr3).merchant([6], {value: ethers.utils.parseEther("0.01")})
      await elvesPolygon.connect(addr3).merchant([7], {value: ethers.utils.parseEther("0.01")})
      await elvesPolygon.connect(addr3).merchant([8], {value: ethers.utils.parseEther("0.01")})
      await elvesPolygon.connect(addr3).merchant([9], {value: ethers.utils.parseEther("0.01")})
      await elvesPolygon.connect(addr3).merchant([10], {value: ethers.utils.parseEther("0.01")})
      await elvesPolygon.connect(addr3).merchant([11], {value: ethers.utils.parseEther("0.01")})
      await elvesPolygon.connect(addr3).merchant([12], {value: ethers.utils.parseEther("0.01")})
      await elvesPolygon.connect(addr3).merchant([13], {value: ethers.utils.parseEther("0.01")})
      await elvesPolygon.connect(addr3).merchant([14], {value: ethers.utils.parseEther("0.01")})
      await elvesPolygon.connect(addr3).merchant([15], {value: ethers.utils.parseEther("0.01")})
      await elvesPolygon.connect(addr3).merchant([16], {value: ethers.utils.parseEther("0.01")})
      await elvesPolygon.connect(addr3).merchant([17], {value: ethers.utils.parseEther("0.01")})
      await elvesPolygon.connect(addr3).merchant([18], {value: ethers.utils.parseEther("0.01")})
      await elvesPolygon.connect(addr3).merchant([19], {value: ethers.utils.parseEther("0.01")})
      await elvesPolygon.connect(addr3).merchant([20], {value: ethers.utils.parseEther("0.01")})
      increaseWorldTimeinSeconds(10000000,true);
      await elvesPolygon.connect(addr4).merchant([21], {value: ethers.utils.parseEther("0.01")})
      await elvesPolygon.connect(addr4).merchant([22], {value: ethers.utils.parseEther("0.01")})
      increaseWorldTimeinSeconds(10000000,true);
      await elvesPolygon.connect(addr5).merchant([23], {value: ethers.utils.parseEther("0.01")})
      await elvesPolygon.connect(addr5).merchant([24], {value: ethers.utils.parseEther("0.01")})
      //increaseWorldTimeinSeconds(10000000,true);
      
      
      console.log(await elvesPolygon.tokenURI(1))



    });});


*/
 
/*
    describe("Test Levels", function () {
      it("Testing correct item leveling", async function () {

      await elvesPolygon.connect(addr3).mint({ value: ethers.utils.parseEther(mintPrice)});
      await elvesPolygon.connect(addr3).mint({ value: ethers.utils.parseEther(mintPrice)});
      await elvesPolygon.connect(addr3).mint({ value: ethers.utils.parseEther(mintPrice)});
      await elvesPolygon.connect(addr3).mint({ value: ethers.utils.parseEther(mintPrice)});

      await elvesPolygon.setElfManually(1,1,1,6,12,10,4,2,2,2)

      await elvesPolygon.connect(addr3).sendCampaign([1],1,5,1,1,1);

      await elvesPolygon.connect(addr3).sendCampaign([2],1,1,1,1,1);

      //10 + (3 * 2) = 16
      console.log("LEVELLLLS")
      console.log("level 16", await elvesPolygon.elves(1))
      console.log("level 4", await elvesPolygon.elves(2))


      console.log("After Campai4gn:");
      //await elvesPolygon.connect(addr3).heal(3,4)
     

      //await elvesPolygon.connect(addr3).bloodThirst([5],1,1)
      increaseWorldTimeinSeconds(10000000,true);
      await elvesPolygon.connect(addr3).sendCampaign([3],1,1,1,1,1);
      console.log("level 5", await elvesPolygon.elves(3))
      increaseWorldTimeinSeconds(10000000,true);
      await elvesPolygon.connect(addr3).sendCampaign([3],1,1,1,1,1);
      console.log("level 8", await elvesPolygon.elves(3))


    });});
*/


 
/*
  describe("Whitelist Mint", function () {
    it("WL Mint Qty 2", async function () {
    

      let sig3 = "0xdc32af9449379cbe2590d10906a4d75a54068b567d1bc7e5e513e60c560805944c850fd88b42e23415a939e18c85c39c4026faa2642d185b282e3cf1d88c666c1b"
      let sig4 = "0x839627587bd83e3c53f33a3d9ee73568c5120f65ab17359815a7b0cd40d61be00ad95184ca00101af08fcfa88e1802533980bae3f151166f794c95e5bccf1d061b"
      let sig5 = "0x20868c80932018ff173bb5eca6628b8071c0664e547cebcf040eab374a525af22ee2669a8afb218e1c56709ac4058898f82298e3a83b10a0e5454e6b6fa4bc3d1c" 

      console.log("Is Signature valid?", await elvesPolygon.validSignature(addr3.address,0, sig3))

      await elvesPolygon.connect(addr3).whitelistMint(2,addr3.address, 0, sig3, { value: ethers.utils.parseEther("0.00")})
      await elvesPolygon.connect(addr4).whitelistMint(2,addr4.address, 1, sig4, { value: ethers.utils.parseEther("0.088")})
      await elvesPolygon.connect(addr5).whitelistMint(2,addr5.address, 2, sig5, { value: ethers.utils.parseEther("0.176")})
    
      });
    it("WL Mint Qty 1", async function () {
    

        let sig3 = "0xdc32af9449379cbe2590d10906a4d75a54068b567d1bc7e5e513e60c560805944c850fd88b42e23415a939e18c85c39c4026faa2642d185b282e3cf1d88c666c1b"
        let sig4 = "0x839627587bd83e3c53f33a3d9ee73568c5120f65ab17359815a7b0cd40d61be00ad95184ca00101af08fcfa88e1802533980bae3f151166f794c95e5bccf1d061b"
        let sig5 = "0x20868c80932018ff173bb5eca6628b8071c0664e547cebcf040eab374a525af22ee2669a8afb218e1c56709ac4058898f82298e3a83b10a0e5454e6b6fa4bc3d1c" 
  
        await elvesPolygon.connect(addr3).whitelistMint(1,addr3.address, 0, sig3, { value: ethers.utils.parseEther("0.00")})
        await elvesPolygon.connect(addr4).whitelistMint(1,addr4.address, 1, sig4, { value: ethers.utils.parseEther("0.044")})
        await elvesPolygon.connect(addr5).whitelistMint(1,addr5.address, 2, sig5, { value: ethers.utils.parseEther("0.088")})
      
        });
    it("Withdraw funds from player credit account to player wallet", async function () {
      await elvesPolygon.setAccountBalance(addr3.address, ethers.BigNumber.from("1000000000000000000000"));
      await elvesPolygon.connect(addr3).withdrawTokenBalance();
  
    expect(await elvesPolygon.bankBalances(addr3.address).value).to.equal(ethers.BigNumber.from("1000000000000000000000").value);
      });

    });  

*/

 /*
  describe("Deployment and ERC20 and ERC721 Minting", function () {
    it("Check contract deployer is owner", async function () {
      expect(await elvesPolygon.admin()).to.equal(owner.address); 
    })
   it("Mint entire NFT collection", async function () {

      await ren.mint(beff.address,  ethers.BigNumber.from("6000000000000000000000")); 
      await ren.mint(addr3.address, ethers.BigNumber.from("6000000000000000000000")); 
      await ren.mint(addr4.address, ethers.BigNumber.from("6000000000000000000000")); 
      await ren.mint(addr5.address, ethers.BigNumber.from("6000000000000000000000")); 

      await elvesPolygon.setAccountBalance(beff.address, ethers.BigNumber.from("120000000000000000000"));
      await elvesPolygon.setAccountBalance(addr3.address, ethers.BigNumber.from("120000000000000000000"));
      await elvesPolygon.setAccountBalance(addr4.address, ethers.BigNumber.from("120000000000000000000"));
      await elvesPolygon.setAccountBalance(addr5.address, ethers.BigNumber.from("100000000000000000000"));
      
      let totalsupply = 1
      let maxSupply = 12//parseInt(await elvesPolygon.maxSupply())
      await elvesPolygon.setInitialSupply(2)
      let initialSupply = parseInt(await elvesPolygon.INIT_SUPPLY())
      let i = 1

      console.log("Actual Max Mint", parseInt(await elvesPolygon.maxSupply()))
      
      while (totalsupply < maxSupply) {
        
          totalsupply<=initialSupply ? await elvesPolygon.connect(beff).mint({ value: ethers.utils.parseEther(mintPrice)}) :   await elvesPolygon.connect(beff).mint();
          console.log(i)
          elvesPolygon.tokenURI(i)
          i++;
          console.log(i)
          totalsupply<=initialSupply ? await elvesPolygon.connect(addr3).mint({ value: ethers.utils.parseEther(mintPrice)}) :  await elvesPolygon.connect(addr3).mint(); 
          elvesPolygon.tokenURI(i)
          i++;
          console.log(i)
          totalsupply<=initialSupply ? await elvesPolygon.connect(addr4).mint({ value: ethers.utils.parseEther(mintPrice)}) :  await elvesPolygon.connect(addr4).mint();
          elvesPolygon.tokenURI(i)
          i++;
          console.log(i)
          totalsupply<=initialSupply ? await elvesPolygon.connect(addr5).mint({ value: ethers.utils.parseEther(mintPrice)}) :  await elvesPolygon.connect(addr5).mint();
          elvesPolygon.tokenURI(i)
          i++;
          console.log(i)
          
        totalsupply = parseInt(await elvesPolygon.totalSupply())
        
        increaseWorldTimeinSeconds(1,true);
        
    
      }
     
      expect(parseInt(await elvesPolygon.totalSupply())).to.equal(maxSupply);
    }  

        
  })
  )*/ 

  /*

describe("Game Play", function () {

  it("Test passive mode unstake function and withdraw of some ren", async function () {
         
    await elvesPolygon.connect(addr3).mint({ value: ethers.utils.parseEther(mintPrice)});
   
    await elvesPolygon.connect(addr3).passive([1])
    increaseWorldTimeinSeconds(1304801,true);
    await elvesPolygon.connect(addr3).unStake([1])
    console.log("Bank Bal afeter 7 day passive", await elvesPolygon.bankBalances(addr3.address))
    await elvesPolygon.connect(addr3).withdrawSomeTokenBalance("130000000000000000000")
    console.log("Bank Bal partial withdraw", await elvesPolygon.bankBalances(addr3.address))
    await elvesPolygon.connect(addr3).passive([1])
    increaseWorldTimeinSeconds(604801,true);
    await elvesPolygon.connect(addr3).returnPassive([1]);
    console.log("Bank Bal afeter 7 day passive - withdraw", await elvesPolygon.bankBalances(addr3.address))
    console.log("Levels:", await elvesPolygon.elves(1))
     // expect(await elvesPolygon.bankBalances(addr3.address).value).to.equal(ethers.BigNumber.from("150000000000000000000").value);
      });


    it("Tests staking and actions", async function () {
      await elvesPolygon.connect(addr3).mint({ value: ethers.utils.parseEther(mintPrice)});
      await elvesPolygon.connect(addr3).mint({ value: ethers.utils.parseEther(mintPrice)});
      await elvesPolygon.connect(addr3).mint({ value: ethers.utils.parseEther(mintPrice)});
      await elvesPolygon.connect(addr3).mint({ value: ethers.utils.parseEther(mintPrice)});
      await elvesPolygon.connect(addr3).mint({ value: ethers.utils.parseEther(mintPrice)});
     

      increaseWorldTimeinSeconds(10,true);


      await elvesPolygon.connect(addr3).sendCampaign([1],1,4,0,1,0);
      console.log (await elvesPolygon.attributes(1))
      increaseWorldTimeinSeconds(100000,true);
      console.log("FAIL")
//      await elvesPolygon.connect(addr3).sendCampaign([1],1,4,0,1,0);
      increaseWorldTimeinSeconds(100000,true);
      console.log (await elvesPolygon.attributes(1))
      await elvesPolygon.connect(addr3).sendCampaign([4],1,5,1,1,2);

      increaseWorldTimeinSeconds(100000,true);
     
      await elvesPolygon.connect(addr3).mint({ value: ethers.utils.parseEther(mintPrice)});
      console.log("After Campaig1n:");
      await elvesPolygon.connect(addr3).passive([3])
      increaseWorldTimeinSeconds(100000,true);
      await elvesPolygon.connect(addr3).unStake([3])



      console.log("After Campaig2n:");
      //await elvesPolygon.connect(addr3).returnPassive([3]);
      await elvesPolygon.connect(addr3).forging([4], {value: ethers.utils.parseEther("0.04")})
      console.log("After Campaig3n:");
      await elvesPolygon.connect(addr3).merchant([4], {value: ethers.utils.parseEther("0.04")})
      await elvesPolygon.connect(addr3).forging([5], {value: ethers.utils.parseEther("0.04")})
      console.log("After Campaig3n:");
      await elvesPolygon.connect(addr3).merchant([5], {value: ethers.utils.parseEther("0.04")})
      await elvesPolygon.connect(addr3).forging([6], {value: ethers.utils.parseEther("0.04")})
      console.log("After Campaig3n:");
      await elvesPolygon.connect(addr3).merchant([6], {value: ethers.utils.parseEther("0.04")})

      console.log("After Campai4gn:");
     // await elvesPolygon.connect(addr3).heal(3,4)
      //await elvesPolygon.connect(addr3).bloodThirst([5],1,1)
      increaseWorldTimeinSeconds(100000,true);
      console.log("After Campa5ign:");
      //await elvesPolygon.connect(addr3).bloodThirst([5],1,1)
      increaseWorldTimeinSeconds(100000,true);
      console.log("After Campai6gn:");
      //await elvesPolygon.connect(addr3).rampage([5],1,1)

      

      // await elvesPolygon.connect(addr3).unStake([1])
      increaseWorldTimeinSeconds(100000,true);
      await elvesPolygon.connect(addr3).passive([6])
      
      //await elvesPolygon.connect(addr3).test(2)

      console.log("Creatures left in camps", await campaigns.camps(1))
      
      elvesPolygon.tokenURI(1)
      elvesPolygon.tokenURI(2)
      elvesPolygon.tokenURI(3)
      elvesPolygon.tokenURI(4)
      elvesPolygon.tokenURI(5)
      elvesPolygon.tokenURI(6)
      
      });

      it("Passive Campaigns", async function () {
        await elvesPolygon.connect(addr3).mint({ value: ethers.utils.parseEther(mintPrice)});
        await elvesPolygon.connect(addr3).mint({ value: ethers.utils.parseEther(mintPrice)});
        await elvesPolygon.connect(addr3).mint({ value: ethers.utils.parseEther(mintPrice)});
        await elvesPolygon.connect(addr3).mint({ value: ethers.utils.parseEther(mintPrice)});
        await elvesPolygon.connect(addr3).passive([1])
        await elvesPolygon.connect(addr3).passive([2])
        await elvesPolygon.connect(addr3).passive([3])
        await elvesPolygon.connect(addr3).passive([4])

        increaseWorldTimeinSeconds(604700,true);
        await elvesPolygon.connect(addr3).unStake([1]);
        console.log(await elvesPolygon.elves(1));
        increaseWorldTimeinSeconds(800,true);
        await elvesPolygon.connect(addr3).returnPassive([2]);

        increaseWorldTimeinSeconds(604800,true);
        await elvesPolygon.connect(addr3).returnPassive([3]);
        increaseWorldTimeinSeconds(604800,true);
        increaseWorldTimeinSeconds(604800,true);
        increaseWorldTimeinSeconds(604800,true);
        await elvesPolygon.connect(addr3).returnPassive([4]);


        elvesPolygon.tokenURI(1)
        elvesPolygon.tokenURI(2)
        elvesPolygon.tokenURI(3)
        elvesPolygon.tokenURI(4)
        
        
        
        });

       

        
  
  


  });


describe("Bank Functions", function () {
    it("Deposit funds to player credit account", async function () {
      await elvesPolygon.setAccountBalance(addr3.address, ethers.BigNumber.from("1000000000000000000000"));

      expect(await elvesPolygon.bankBalances(addr3.address).value).to.equal(ethers.BigNumber.from("1000000000000000000000").value);
      });
    it("Withdraw funds from player credit account to player wallet", async function () {
      await elvesPolygon.setAccountBalance(addr3.address, ethers.BigNumber.from("2000000000000000000000"));
      await elvesPolygon.connect(addr3).withdrawSomeTokenBalance("1000000000000000000000")
      await elvesPolygon.connect(addr3).withdrawTokenBalance();
  
    expect(await elvesPolygon.bankBalances(addr3.address).value).to.equal(ethers.BigNumber.from("1000000000000000000000").value);
      });
    });

  

describe("Admin Functions", function () {
  it("Withdraw funds from contract", async function () {
    await elvesPolygon.connect(addr4).mint({ value: ethers.utils.parseEther(mintPrice)});
    await elvesPolygon.connect(addr3).mint({ value: ethers.utils.parseEther(mintPrice)});
    elvesPolygon.withdrawAll();
    expect(await owner.getBalance().value).to.equal(await beff.getBalance().value);
    });
  it("Add new camp for quests and see if correct rewards are loaded", async function () {
      await campaigns.addCamp(6, 99, 500, 9, 10, 1, 50);
     
      
    });
    it("Flip game active status", async function () {
      await elvesPolygon.flipActiveStatus()
      expect(await elvesPolygon.isGameActive()).to.equal(false);
      
    });
  });

  
*/


