const fs = require('fs-extra');
const path = require('path');

const {expect} = require("chai");
const {ethers, waffle} = require("hardhat");
const {

    initEthers,
    assertThrowsMessage,
    signPackedData,
    getTimestamp,
    increaseBlockTimestampBy

} = require('./helpers');


const increaseWorldTimeinSeconds = async (seconds, mine = false) => {

    await ethers.provider.send("evm_increaseTime", [seconds]);
    if (mine) {

        await ethers.provider.send("evm_mine", []);

    }

};

const validator = "0x80861814a8775de20F9506CF41932E95f80f7035";


describe("Ethernal Elves Contracts", function () {

    let owner;
    let beff;
    let addr3;
    let addr4;
    let addr5;
    let addrs;
    let ren;
    let pRen;
    let ethElves;
    let inventory;
    let campaigns;
    let eBridge;
    let pBridge;
    let artifacts;
    let moon;
    let dao;
    let slp;
    let wallet;
    let elders;
    let eldersInventory;


    // `beforeEach` will run before each test, re-deploying the contract every
    // time. It receives a callback, which can be async.
    beforeEach(async function () {

        // Get the ContractFactory and Signers here.
        // Deploy each contract and Initialize main contract with varialbes

        [
            owner,
            beff,
            addr3,
            addr4,
            addr5,
            ... addrs
        ] = await ethers.getSigners();

        // owner and beff are dev wallets. addr3 and addr4 will be used to test the game and transfer/banking functions

        const MetadataHandler = await ethers.getContractFactory("ElfMetadataHandlerV2");
        const Miren = await ethers.getContractFactory("Miren");
        const Pmiren = await ethers.getContractFactory("pMiren");
        const Moon = await ethers.getContractFactory("Moon");
        const SLP = await ethers.getContractFactory("SLP");
        const Wallet = await ethers.getContractFactory("ElvenWalletV2");
        const Elves = await ethers.getContractFactory("EETest");
        const Pelves = await ethers.getContractFactory("EETestPolygon");
        const Campaigns = await ethers.getContractFactory("ElfCampaignsV3");
        const Artifacts = await ethers.getContractFactory("Artifacts");
        const Bridge = await ethers.getContractFactory("PrismBridge");
        // const ElvenDao = await ethers.getContractFactory("ElvenDao");
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


        const Elders = await ethers.getContractFactory("Elders");


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

        artifacts = await upgrades.deployProxy(Artifacts);


        ren = await Miren.deploy();
        pRen = await Pmiren.deploy();
        moon = await Moon.deploy();
        wallet = await upgrades.deployProxy(Wallet);

        slp = await SLP.deploy();
        moon.deployed();


        eBridge = await upgrades.deployProxy(Bridge);
        pBridge = await upgrades.deployProxy(Bridge);
        // dao = ElvenDao.deploy(moon.address);


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


        await inventory.setRace([
            1,
            10,
            11,
            12,
            2,
            3
        ], race1.address);
        await inventory.setRace([
            4,
            5,
            6,
            7,
            8,
            9
        ], race2.address);
        await inventory.setHair([
            1,
            2,
            3,
            4,
            5,
            6,
            7,
            8,
            9
        ], hair.address);
        await inventory.setWeapons([
            1,
            10,
            11,
            12,
            13,
            14,
            15
        ], weapons1.address);
        await inventory.setWeapons([
            23,
            24,
            25,
            26,
            27,
            28,
            29
        ], weapons2.address);
        await inventory.setWeapons([
            38,
            39,
            4,
            40,
            41,
            42
        ], weapons3.address);
        await inventory.setWeapons([
            16,
            17,
            18,
            19,
            2,
            20,
            21,
            22
        ], weapons4.address);
        await inventory.setWeapons([
            3,
            30,
            31,
            32,
            33,
            34,
            35,
            36,
            37
        ], weapons5.address);
        await inventory.setWeapons([
            43,
            44,
            45,
            5,
            6,
            7,
            8,
            9,
            69
        ], weapons6.address);
        await inventory.setAccessories([
            15,
            16,
            4,
            5,
            8,
            9,
            1,
            2,
            3,
            6,
            7,
            10,
            11,
            12,
            13,
            14,
            17,
            18,
            19,
            20,
            21
        ], accessories.address);
        await inventory.setAccessories([
            2, 3
        ], accessories3.address);
        await inventory.setAccessories([
            10, 11, 17, 18
        ], accessories4.address);
        await inventory.setAccessories([
            6, 12, 13
        ], accessories5.address);
        await inventory.setAccessories([
            14, 19
        ], accessories6.address);
        await inventory.setAccessories([
            20, 21
        ], accessories7.address);


        await ren.setMinter(ethElves.address, 1);
        await ren.setMinter(owner.address, 1);
        await moon.setMinter(elvesPolygon.address);
        await moon.setMinter(owner.address);
        await pRen.setMinter(elvesPolygon.address, 1);
        await pRen.setMinter(wallet.address, 1);
        await pRen.setMinter(owner.address, 1);
        await slp.setMinter(owner.address, 1);

        await wallet.setAddresses(elvesPolygon.address, pRen.address, moon.address, slp.address);
        await wallet.setAuth([
            addr3.address, addr4.address, addr5.address
        ], true);
        await wallet.setMoonForLP("1400000000000000000000000");

        await elvesPolygon.setAuth([
            owner.address, addr3.address, pBridge.address
        ], true);

        await ethElves.flipActiveStatus();
        await eBridge.setAddresses(ethElves.address, validator);
        await pBridge.setAddresses(elvesPolygon.address, validator);

        await ethElves.setBridge(eBridge.address);
        await ethElves.setInitialAddress(ren.address, inventory.address, eBridge.address);

        await elders.setAddresses(artifacts.address, inventory.address);
        await elvesPolygon.setCreatureHealth("420");
        await elvesPolygon.addScrollsForSale(100, 750);

        // mint some elves
        let level = [
            1,
            77,
            100,
            99,
            100,
            60,
            45
        ];
        let sentineClass = [0, 1, 2];
        let race = [0, 1, 2, 3];
        let axa = [
            0,
            1,
            2,
            3,
            4,
            5,
            6
        ];
        let item = [
            0,
            1,
            2,
            3,
            4,
            5,
            6
        ];
        let weapon = [
            1,
            2,
            3,
            4,
            5,
            6,
            7,
            8,
            9,
            10,
            11,
            12,
            13,
            14
        ];
        let weaponTier = [
            1,
            2,
            3,
            4,
            5
        ];

        // MINT TEST ELVES ON POLYGON
        await elvesPolygon.connect(addr3).mint(level[0], axa[0], race[0], sentineClass[1], item[3], weapon[0], weaponTier[3]);
        await elvesPolygon.connect(addr3).mint(level[1], axa[0], race[0], sentineClass[2], item[2], weapon[0], weaponTier[2]);
        await elvesPolygon.connect(addr3).mint(level[2], axa[1], race[0], sentineClass[0], item[6], weapon[0], weaponTier[4]);

        await elvesPolygon.connect(addr4).mint(10, 1, 1, 1, 0, 1, 1);
        await elvesPolygon.connect(addr4).mint(10, 1, 1, 0, 0, 1, 1);
        // DRUID
        // one for ones
        await elvesPolygon.connect(addr3).mint(level[2], axa[5], race[0], sentineClass[0], item[3], weapon[12], weaponTier[4]);
        await elvesPolygon.connect(addr3).mint(level[2], axa[4], race[0], sentineClass[1], item[2], weapon[12], weaponTier[4]);
        await elvesPolygon.connect(addr3).mint(level[2], axa[4], race[0], sentineClass[2], item[4], weapon[12], weaponTier[4]);
        // FOr Transfers
        await elvesPolygon.connect(addr3).mint(level[0], axa[0], race[0], sentineClass[1], item[3], weapon[0], weaponTier[0]);
        await elvesPolygon.connect(addr3).mint(level[1], axa[0], race[0], sentineClass[2], item[2], weapon[0], weaponTier[0]);
        await elvesPolygon.connect(addr3).mint(level[2], axa[1], race[0], sentineClass[0], item[6], weapon[0], weaponTier[0]);

        // MIN TEST ELVES ON ETH
        await ethElves.connect(addr3).mint(level[0], axa[0], race[0], sentineClass[1], item[3], weapon[0], weaponTier[0]);
        await ethElves.connect(addr3).mint(level[1], axa[0], race[0], sentineClass[2], item[2], weapon[0], weaponTier[0]);
        await ethElves.connect(addr3).mint(level[2], axa[1], race[0], sentineClass[0], item[6], weapon[0], weaponTier[0]);


        let fundRen = "100000000000000000000000";
        let slpFund = "400000000000000000000000";
        await elvesPolygon.adminSetAccountBalance(addr3.address, fundRen);
        await ren.mint(addr3.address, fundRen);

        await slp.mint(addr3.address, slpFund);
        await slp.mint(addr4.address, slpFund);
        await slp.mint(addr5.address, slpFund);
        await moon.mint(wallet.address, "1400000000000000000000000");

    });

    describe("Elders", function () {



        it("Mint Elders for Artifacts", async function () {

            await artifacts.reserve(14);
            await elders.mint(2);



        });



    });

    describe("Off Chain gameplay", function () {



        it("Checks sentinel ID returned", async function () {



            // address owner, uint256 timestamp, uint256 action, uint256 healthPoints,
            // uint256 attackPoints, uint256 primaryWeapon, uint256 level,
            // uint256 traits, uint256 class)

            // sentinel |= traits<<240; //DataStructures.packAttributes(hair, race, accessories);
            // sentinel |= class<<248; //DataStructures.packAttributes(sentinelClass, weaponTier, inventory);

            const owner = "0xe7AF77629e7ECEd41C7B7490Ca9C4788F7c385E5";
            const timestamp = parseInt(new Date().getTime() / 1000); // 1649649495 // 1652884012
            const action = 2;
            const healthPoints = 23;
            const attackPoints = 23;
            const primaryWeapon = 13;
            const level = 100;
            const traits = 222;
            const classPacked = 252;

            let result = await elvesPolygon.generateSentinelDna(owner, timestamp, action, healthPoints, attackPoints, primaryWeapon, level, traits, classPacked);
            console.log("packed attributes", result);
            console.log(timestamp);
            let resultString = "114375768418909564496455534786242004693728363386313769181303552442284395169253";
            console.log("result String", resultString);
            let decodeResult = await elvesPolygon.decodeSentinelDna(resultString);
            console.log("decoded attributes", decodeResult);





        });



    });

    describe("LP Stuff", function () {



        it("EXCHANGE SLP FOR TOKENS", async function () {





            await slp.connect(addr3).approve(wallet.address, "10000000000000000000000000000000000000000");
            await slp.connect(addr4).approve(wallet.address, "10000000000000000000000000000000000000000");
            await slp.connect(addr5).approve(wallet.address, "10000000000000000000000000000000000000000");

            let remainTokens = 1400000000;
            let count = 0;

            while (remainTokens > 1000000) {

                await wallet.connect(addr3).exchangeSLPForMoon(addr3.address, "25000000000000000000"); // 25
                await wallet.connect(addr4).exchangeSLPForMoon(addr4.address, "35000000000000000000"); // 23
                await wallet.connect(addr5).exchangeSLPForMoon(addr5.address, "50000000000000000000"); // 50
                count = count + 3;
                remainTokens = parseInt(await wallet.moonForLPsLeft() / 1000000000000000000);



            }
            console.log("total txs:", count);
            console.log("SLP BALANCE: ", parseInt(await slp.balanceOf(wallet.address)) / 1000000000000000000);
            console.log("MOON FOR LPS REMAIN: ", parseInt(await wallet.moonForLPsLeft() / 1000000000000000000), "SLP SWAPRATE: ", parseInt(await wallet.getSlpSwapRate()));



        });



    });


    it("Mint Artifacts", async function () { // await artifacts.mint(10, 1600, "0x93b53bfab6b02ccb4212ede5fecba3545a0643d6406f617cde50f3cae453d361549b2db31285f82d307ac6e28177dd3ea9cb6c16d7e8aef64e566e44db0bdc871b");
        await artifacts.reserve(10);
        // console.log(await artifacts.uri(1337))
        console.log(await artifacts.balanceOf(owner.address, 1));

        await artifacts.burn(owner.address, 1, 2);
        console.log("//BREAKER//");
        console.log(await artifacts.balanceOf(owner.address, 1));
        console.log(await artifacts.uri(1));





    });


    describe("New Features", function () {





        it("CHECK IN BRIDGE ETH", async function () {

            await eBridge.connect(addr3).checkIn([
                1, 2, 3
            ], [], 0, 10000000, addr3.address, 1);
            // await eBridge.connect(addr3).checkIn([1,2,3],[],0,10000000,addr3.address,1)





        });

        it("CHECK IN BRIDGE POLYGON", async function () {



            await pBridge.connect(addr3).checkIn([
                9, 10, 11
            ], [], 0, 10000000, addr3.address, 1);
            // await pBridge.connect(addr3).checkIn([9,10,11],[],0,10000000,addr3.address,1)





        });





    });





});
