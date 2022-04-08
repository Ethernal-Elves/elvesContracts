// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.7;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "./PolyElvesERC721.sol"; 
import "./../DataStructures.sol";
import "./../Interfaces.sol";
//import "hardhat/console.sol";

/*
███████╗████████╗██╗░░██╗███████╗██████╗░███╗░░██╗░█████╗░██╗░░░░░  ███████╗██╗░░░░░██╗░░░██╗███████╗░██████╗
██╔════╝╚══██╔══╝██║░░██║██╔════╝██╔══██╗████╗░██║██╔══██╗██║░░░░░  ██╔════╝██║░░░░░██║░░░██║██╔════╝██╔════╝
█████╗░░░░░██║░░░███████║█████╗░░██████╔╝██╔██╗██║███████║██║░░░░░  █████╗░░██║░░░░░╚██╗░██╔╝█████╗░░╚█████╗░
██╔══╝░░░░░██║░░░██╔══██║██╔══╝░░██╔══██╗██║╚████║██╔══██║██║░░░░░  ██╔══╝░░██║░░░░░░╚████╔╝░██╔══╝░░░╚═══██╗
███████╗░░░██║░░░██║░░██║███████╗██║░░██║██║░╚███║██║░░██║███████╗  ███████╗███████╗░░╚██╔╝░░███████╗██████╔╝
╚══════╝░░░╚═╝░░░╚═╝░░╚═╝╚══════╝╚═╝░░╚═╝╚═╝░░╚══╝╚═╝░░╚═╝╚══════╝  ╚══════╝╚══════╝░░░╚═╝░░░╚══════╝╚═════╝░
*/

// We are the Ethernal. The Ethernal Elves         
// Written by 0xHusky & Beff Jezos. Everything is on-chain for all time to come.
// Version 4.0.1
// Release notes: Adding Rampage and new abilities based on accessories e

contract PolyEthernalElvesV4 is PolyERC721 {

    function name() external pure returns (string memory) { return "Polygon Ethernal Elves"; }
    function symbol() external pure returns (string memory) { return "pELV"; }
       
    //using DataStructures for DataStructures.ActionVariables;
    using DataStructures for DataStructures.Elf;
    //using DataStructures for DataStructures.Token; 

    IElfMetaDataHandler elfmetaDataHandler;
        
    using ECDSA for bytes32;

/*
█▀ ▀█▀ ▄▀█ ▀█▀ █▀▀   █░█ ▄▀█ █▀█ █▀
▄█ ░█░ █▀█ ░█░ ██▄   ▀▄▀ █▀█ █▀▄ ▄█
*/

    bool public isGameActive;
    bool public isTerminalOpen;
    bool private initialized;

    address operator;
   
    uint256 public INIT_SUPPLY; 
    uint256 public price;
    uint256 public MAX_LEVEL;
    uint256 public TIME_CONSTANT; 
    uint256 public REGEN_TIME; 
 
    bytes32 internal ketchup;
    
    mapping(uint256 => uint256) public sentinels; //memory slot for Elfs
    mapping(address => uint256) public bankBalances; //memory slot for bank balances
    mapping(uint256 => Camps) public camps; //memory slot for campaigns

    struct Camps {
                uint32 baseRewards; 
                uint32 creatureCount; 
                uint32 creatureHealth; 
                uint32 expPoints; 
                uint32 minLevel;
                uint32 campMaxLevel;
        }    
   
    mapping(address => bool)    public auth;  
    mapping(bytes => uint16)  public usedRenSignatures;
    address polyValidator;
    
   
    mapping(uint256 => Rampages) public rampages; //memory slot for campaigns
    bool private isRampageInit;
    struct Rampages {

                uint16 probDown; 
                uint16 probSame; 
                uint16 propUp; 
                uint16 levelsGained; 
                uint16 minLevel;
                uint16 maxLevel;
                uint16 renCost;     
                uint16 count; 

        }
    
    struct GameVariables {
                
                uint256 healTime; 
                uint256 instantKillModifier;     
                uint256 rewardModifier;     
                uint256 attackPointModifier;     
                uint256 healthPointModifier;     
                uint256 reward;
                uint256 timeDiff;
                uint256 traits; 
                uint256 class;  

    }
    
   
    mapping(uint256 => PawnItems) public pawnItems; //memory slot for campaigns
    
    struct PawnItems {
                
                uint256 buyPrice; 
                uint256 sellPrice;     
                uint256 maxSupply;     
                uint256 currentInventory;     
    }

     //NewDataSlots from this deployment///

    //CRUSADER NO REGRET// 
    ///////////////////////////////////////////////////////////////////////////////////////////
    mapping(address => uint256) public scrolls; //memory slot for scrolls to go on crusades////
    mapping(address => uint256) public artifacts; //memory slot for artifact mint           ///
    mapping(uint256 => uint256) public onCrusade;                                           /// 
    ///////////////////////////////////////////////////////////////////////////////////////////
    
   
    /*
    function initialize() public {
    
       require(!initialized, "Already initialized");
       admin                = msg.sender;   
       initialized          = true;
       operator             = 0xa2B877EC3234F50C33Ff7d0605F7591053d06E31; 
       elfmetaDataHandler   = IElfMetaDataHandler(0x3cF1630393BFd1D9fF52bD822fE88714FC81467E);

       camps[1] = Camps({baseRewards: 10, creatureCount: 1000, creatureHealth: 120,  expPoints:6,   minLevel:1, campMaxLevel:100});

       MAX_LEVEL = 100;
       TIME_CONSTANT = 1 hours; 
       REGEN_TIME = 300 hours; 

    }  */  

    /*function initializeRampage() public {
    
       require(!isRampageInit, "Already initialized");
       isRampageInit = true;
       rampages[1] = Rampages({probDown:  0, probSame:  0, propUp:  0, levelsGained: 3, minLevel: 1, maxLevel:100, renCost: 75,  count:10000});
       rampages[2] = Rampages({probDown:  0, probSame:  0, propUp:  0, levelsGained: 5, minLevel:60, maxLevel:100, renCost:125,  count:8000});
       //Accessories & Weapons
       rampages[3] = Rampages({probDown: 20, probSame: 50, propUp: 30, levelsGained: 0, minLevel:60, maxLevel:100, renCost:300,  count:4000});
       rampages[4] = Rampages({probDown:  5, probSame: 30, propUp: 65, levelsGained: 0, minLevel:75, maxLevel:100, renCost:600,  count:2000});
       rampages[5] = Rampages({probDown:  0, probSame: 10, propUp: 90, levelsGained: 0, minLevel:99, maxLevel:100, renCost:1200, count:667});
       //Morphset
       rampages[6] = Rampages({probDown:  0, probSame: 50, propUp: 50, levelsGained: 0, minLevel:99, maxLevel:100, renCost:5000, count:100});       
       rampages[7] = Rampages({probDown:  0, probSame: 50, propUp: 50, levelsGained: 0, minLevel:99, maxLevel:100, renCost:6500, count:100});              
    }*/
 
    


/*
█▀▀ █░█ █▀▀ █▄░█ ▀█▀ █▀
██▄ ▀▄▀ ██▄ █░▀█ ░█░ ▄█
*/

    event Action(address indexed from, uint256 indexed action, uint256 indexed tokenId);         
    event BalanceChanged(address indexed owner, uint256 indexed amount, bool indexed subtract);
    event Campaigns(address indexed owner, uint256 amount, uint256 indexed campaign, uint256 sector, uint256 indexed tokenId);
    event CheckIn(address indexed from, uint256 timestamp, uint256 indexed tokenId, uint256 indexed sentinel);      
    event RenTransferOut(address indexed from, uint256 timestamp, uint256 indexed renAmount);   
    event LastKill(address indexed from); 
    event AddCamp(uint256 indexed id, uint256 baseRewards, uint256 creatureCount, uint256 creatureHealth, uint256 expPoints, uint256 minLevel);
    event BloodThirst(address indexed owner, uint256 indexed tokenId); 
    event ElfTransferedIn(uint256 indexed tokenId, uint256 sentinel); 
    event RenTransferedIn(address indexed from, uint256 renAmount); 
    event RollOutcome(uint256 indexed tokenId, uint256 roll, uint256 action);
    event ArtifactFound(address indexed from, uint256 artifacts, uint256 indexed tokenId);
    event ArtifactsMinted(address indexed from, uint256 artifacts, uint256 timestamp);
       


/*
█▀▀ ▄▀█ █▀▄▀█ █▀▀ █▀█ █░░ ▄▀█ █▄█
█▄█ █▀█ █░▀░█ ██▄ █▀▀ █▄▄ █▀█ ░█░
*/


    function sendCampaign(uint256[] calldata ids, uint256 campaign_, uint256 sector_, bool rollWeapons_, bool rollItems_, bool useitem_, address owner) external {
                  
         onlyOperator();
          for (uint256 index = 0; index < ids.length; index++) {  
            _actions(ids[index], 2, owner, campaign_, sector_, rollWeapons_, rollItems_, useitem_, 1);
          }
    }


    function passive(uint256[] calldata ids, address owner) external {
                  
        onlyOperator();
          for (uint256 index = 0; index < ids.length; index++) {  
            _actions(ids[index], 3, owner, 0, 0, false, false, false, 0);
          }
    }

    function returnPassive(uint256[] calldata ids, address owner) external  {
               
         onlyOperator();
          for (uint256 index = 0; index < ids.length; index++) {  
            _actions(ids[index], 4, owner, 0, 0, false, false, false, 0);
          }
    }

    function forging(uint256[] calldata ids, address owner) external {
              
         onlyOperator();
          for (uint256 index = 0; index < ids.length; index++) {  
            _actions(ids[index], 5, owner, 0, 0, false, false, false, 0);
          }
    }

    function merchant(uint256[] calldata ids, address owner) external {
          
        onlyOperator();
          for (uint256 index = 0; index < ids.length; index++) {  
            _actions(ids[index], 6, owner, 0, 0, false, false, false, 0);
          }

    }

    function heal(uint256 healer, uint256 target, address owner) external {
        onlyOperator();
        _actions(healer, 7, owner, target, 0, false, false, false, 0);
    }

     function healMany(uint256[] calldata healers, uint256[] calldata targets, address owner) external {
        onlyOperator();
        
        for (uint256 index = 0; index < healers.length; index++) {  
            _actions(healers[index], 7, owner, targets[index], 0, false, false, false, 0);
        }
    }

    
     function synergize(uint256[] calldata ids, address owner) external {
        onlyOperator();
          for (uint256 index = 0; index < ids.length; index++) {  
            _actions(ids[index], 9, owner, 0, 0, false, false, false, 0);
          }

    }

    
 function bloodThirst(uint256[] calldata ids, bool rollItems_, bool useitem_, address owner) external {
          onlyOperator();       

          for (uint256 index = 0; index < ids.length; index++) {  
            _actions(ids[index], 10, owner, 0, 0, false, rollItems_, useitem_, 2);
          }
    }
  
 function rampage(uint256[] calldata ids, uint256 campaign_, bool tryWeapon_, bool tryAccessories_, bool useitem_, address owner) external {
          onlyOperator();       
          //using items bool for try accessories
          for (uint256 index = 0; index < ids.length; index++) {  
            _actions(ids[index], 11, owner, campaign_, 0, tryWeapon_, tryAccessories_, useitem_, 0);
          }
    }

  function buyItem(uint256 id, uint256 itemIndex_,address owner) external {
          onlyOperator();       
         //using sector for item index. The item you want to buy.
          _actions(id, 12, owner, 0, itemIndex_, false,false,false, 0);
          
    }   

    function sellItem(uint256 id, address owner) external {
          onlyOperator();       
        
          _actions(id, 13, owner, 0, 0, false,false,false, 0);
          
    }

     function sendCrusade(uint256[] calldata ids, address owner) external {
          onlyOperator();       
          //using items bool for try accessories
          for (uint256 index = 0; index < ids.length; index++) {  
            _actions(ids[index], 14, owner, 0, 0, false,false, false, 0);
          }
    }

     function returnCrusade(uint256[] calldata ids, address owner) external {
          onlyOperator();       

          for (uint256 index = 0; index < ids.length; index++) {  
                
                _returnCrusade(ids[index], owner);
          }
    } 
 

/*
█ █▄░█ ▀█▀ █▀▀ █▀█ █▄░█ ▄▀█ █░░ █▀
█ █░▀█ ░█░ ██▄ █▀▄ █░▀█ █▀█ █▄▄ ▄█
*/

        function _actions(
            uint256 id_, 
            uint action, 
            address elfOwner, 
            uint256 campaign_, 
            uint256 sector_, 
            bool rollWeapons, 
            bool rollItems, 
            bool useItem, 
            uint256 gameMode_) 
        
        private {

            DataStructures.Elf memory elf = DataStructures.getElf(sentinels[id_]);
            GameVariables memory actions;
            require(isGameActive);
            require(elf.owner == elfOwner, "notYourElf");
            require(onCrusade[id_] == 0, "onCrusade");
             
            
            //Set special abilities when we retrieve the elf so they can be used in the rest of the game loop.            
            (elf.attackPoints, actions) = _getAbilities(elf.attackPoints, elf.accessories, elf.sentinelClass);

            uint256 rand = _rand();
                
                if(action == 0){//Unstake in Eth, Return to Eth in Polygon
                    
                    require(elf.timestamp < block.timestamp, "elfBusy");
                    
                     if(elf.action == 3){
                     actions.timeDiff = (block.timestamp - elf.timestamp) / 1 days; //amount of time spent in camp CHANGE TO 1 DAYS!
                     elf.level = _exitPassive(actions.timeDiff, elf.level, elfOwner);
                    
                     }
                         

                }else if(action == 2){//campaign loop 

                    require(elf.timestamp < block.timestamp, "elfBusy");
                    require(elf.action != 3, "exitPassive"); 

                        (elf.level, actions.reward, elf.timestamp, elf.inventory) = _campaigns(campaign_, sector_, elf.level, elf.attackPoints, elf.healthPoints, elf.inventory, useItem);

                             if(rollWeapons) (elf.primaryWeapon, elf.weaponTier) = _rollWeapon(elf.level, id_, rand, 3);
                             if(rollItems) elf.inventory = _rollitems(id_);                       

                        emit Campaigns(elfOwner, actions.reward, campaign_, sector_, id_);                 

                     _setAccountBalance(elfOwner, actions.reward, false);
                 
                
                }else if(action == 3){//passive campaign

                    require(elf.timestamp < block.timestamp, "elfBusy");
                    elf.timestamp = block.timestamp; //set timestamp to current block time

                }else if(action == 4){///return from passive mode
                    
                    require(elf.action == 3);                    

                    actions.timeDiff = (block.timestamp - elf.timestamp) / 1 days; 

                    elf.level = _exitPassive(actions.timeDiff, elf.level, elfOwner);
                   

                }else if(action == 5){//forging
                   
                    //require(bankBalances[elfOwner] >= 200 ether, "notEnoughRen");
                    checkRen(elfOwner, 200 ether);
                    require(elf.action != 3, "exitPassive");  //Cant roll in passve mode  

                    _setAccountBalance(elfOwner, 200 ether, true);
                    (elf.primaryWeapon, elf.weaponTier) = _rollWeapon(elf.level, id_, rand, 3);
   
                
                }else if(action == 6){//item or merchant loop
                   
                    //require(bankBalances[elfOwner] >= 10 ether, "notEnoughRen");
                    checkRen(elfOwner, 10 ether);
                    require(elf.action != 3, "exitPassive");  //Cant roll in passve mode
                  
                    _setAccountBalance(elfOwner, 10 ether, true);
                     elf.inventory = _rollitems(id_);
                    //(elf.weaponTier, elf.primaryWeapon, elf.inventory) = DataStructures.roll(id_, elf.level, rand, 2, elf.weaponTier, elf.primaryWeapon, elf.inventory);                      

                }else if(action == 7){//healing loop


                    require(elf.sentinelClass == 0, "notDruid"); 
                    require(elf.action != 3, "exitPassive");  //Cant heal in passve mode
                    require(elf.timestamp < block.timestamp, "elfBusy");

                    
                    elf.timestamp = block.timestamp + (actions.healTime);//change to healtime

                    elf.level = elf.level + 1;
                    
                    {   

                        DataStructures.Elf memory hElf = DataStructures.getElf(sentinels[campaign_]);//using the campaign varialbe for elfId here.
                        require(hElf.owner == elfOwner, "notYourElf");
                        //require(hElf.action != 14, "onCrusade"); //Cant heal a crusader
                        require(onCrusade[campaign_] == 0, "onCrusade");      //using the campaign varialbe for elfId here.
                                if(block.timestamp < hElf.timestamp){

                                        actions.timeDiff = hElf.timestamp - block.timestamp;
                
                                        actions.timeDiff = actions.timeDiff > 0 ? 
                                            
                                            hElf.sentinelClass == 0 ? 0 : 
                                            hElf.sentinelClass == 1 ? actions.timeDiff * 1/4 : 
                                            actions.timeDiff * 1/2
                                        
                                        : actions.timeDiff;
                                        
                                        hElf.timestamp = hElf.timestamp - actions.timeDiff;                        
                                        
                                }
                            
                        actions.traits = DataStructures.packAttributes(hElf.hair, hElf.race, hElf.accessories);
                        actions.class =  DataStructures.packAttributes(hElf.sentinelClass, hElf.weaponTier, hElf.inventory);
                                
                        sentinels[campaign_] = DataStructures._setElf(hElf.owner, hElf.timestamp, hElf.action, hElf.healthPoints, hElf.attackPoints, hElf.primaryWeapon, hElf.level, actions.traits, actions.class);

                }
                //Action 8 is move to polygon
                }else if(action == 9){//Re-roll cooldown aka Synergize

                    //require(bankBalances[elfOwner] >= 5 ether, "notEnoughRen");
                    checkRen(elfOwner, 5 ether);
                    require(elf.sentinelClass == 0, "notDruid"); 
                    require(elf.action != 3, "exitPassive"); //Cant heal in passve mode
                    
                    _setAccountBalance(elfOwner, 5 ether, true);
                    elf.timestamp = _rollCooldown(elf.timestamp, id_, rand);

                }else if(action == 10){//Bloodthirst

                    require(elf.timestamp < block.timestamp, "elfBusy");
                    require(elf.action != 3, "exitPassive");  

                       (actions.reward, elf.timestamp, elf.inventory) = _bloodthirst(campaign_, sector_, elf.weaponTier, elf.level, elf.attackPoints, elf.healthPoints, elf.inventory, useItem);

                       if(rollItems){
                       
                       // (elf.weaponTier, elf.primaryWeapon, elf.inventory) = DataStructures.roll(id_, elf.level, _rand(), 2, elf.weaponTier, elf.primaryWeapon, elf.inventory);  
                        elf.inventory = _rollitems(id_);
                       }    

                        
                       if(elf.sentinelClass == 1){
                            
                                elf.timestamp = _instantKill(elf.timestamp, elf.weaponTier, elfOwner, id_, actions.instantKillModifier);
                
                       }
                

                       _setAccountBalance(elfOwner, actions.reward, false);                 
                    
                
                }else if(action == 11){//Rampage
                        require(elf.action != 3, "exitPassive"); //Cant rampage in passve mode
                        require(elf.timestamp < block.timestamp, "elfBusy");
                        
                        //in rampage you can get accessories or weapons.
                       (elf, actions) = _rampage(elf, actions, campaign_, id_, elfOwner, rollWeapons, rollItems, useItem);                
                
                }else if(action == 12){//Buy Item - pawn shop is selling
                      require(elf.action != 3, "exitPassive");
                      //using sector for requested item
                        elf.inventory = _sellItem(sector_, elfOwner); 
                     
                }else if(action == 13){//Sell Item pawnshop is buying
                     require(elf.action != 3, "exitPassive"); 
                     elf.inventory = _buyItem(elf.inventory, elfOwner);                     

                }else if(action == 14){//Go on a Crusade
                     require(elf.action != 3, "exitPassive"); 
                     require(elf.timestamp < block.timestamp, "elfBusy");      
                     require(scrolls[elfOwner] > 0, "noScrolls");
                     //require(bankBalances[elfOwner] >= 1500 ether, "notEnoughRen");
                     checkRen(elfOwner, 1500 ether);
                     
                     _setAccountBalance(elfOwner, 1500 ether, true); // take ren from buyer
                     scrolls[elfOwner] = scrolls[elfOwner] - 1;
                     onCrusade[id_] = 1;

                    uint16 chance = uint16(_randomize(rand, "Inventory", id_));

                             if(elf.level < 70){
                        
                                 elf.timestamp = block.timestamp + (9 days);
                     
                            }else if(elf.level >= 70 && elf.level <= 98){
                                
                                  elf.timestamp = block.timestamp + (7 days);

                            }else if(elf.level > 98){

                                elf.timestamp = block.timestamp + (5 days);

                        }

                  }
             
           
            actions.traits   = DataStructures.packAttributes(elf.hair, elf.race, elf.accessories);
            actions.class    = DataStructures.packAttributes(elf.sentinelClass, elf.weaponTier, elf.inventory);
           
            //Buffer overun protection for Ranger 
            actions.class = actions.class == 256 ? 255 : actions.class;           
           

            elf.healthPoints = DataStructures.calcHealthPoints(elf.sentinelClass, elf.level); 
            elf.attackPoints = DataStructures.calcAttackPoints(elf.sentinelClass, elf.weaponTier);  
            elf.level        = elf.level > 100 ? 100 : elf.level; 
            elf.action       = action;

            sentinels[id_] = DataStructures._setElf(elf.owner, elf.timestamp, elf.action, elf.healthPoints, elf.attackPoints, elf.primaryWeapon, elf.level, actions.traits, actions.class);
            emit Action(elfOwner, action, id_); 
    }

    

function _campaigns(uint256 _campId, uint256 _sector, uint256 _level, uint256 _attackPoints, uint256 _healthPoints, uint256 _inventory, bool _useItem) internal
 
 returns(uint256 level, uint256 rewards, uint256 timestamp, uint256 inventory){
  
  Camps memory camp = camps[_campId];  
  
  require(camp.minLevel <= _level, "levelLow");
  require(camp.campMaxLevel >= _level, "levelHigh"); 
  require(camp.creatureCount > 0, "noSupply");
  
  camps[_campId].creatureCount = camp.creatureCount - 1;  

  level = (uint256(camp.expPoints)/3); //convetrt xp to levels. Level here is the rewards level

  rewards = camp.baseRewards + (2 * (_sector - 1));
  rewards = rewards * (1 ether);      

  inventory = _inventory;
 
  if(_useItem){

       (inventory, level, _attackPoints, _healthPoints, rewards) = _useInventory(_inventory, level, _attackPoints, _healthPoints, rewards);

  }

  level = _level + level;  //add level to current level
  level = level < MAX_LEVEL ? level : MAX_LEVEL; //if level is greater than max level, set to max level
                             
  uint256 creatureHealth =  ((_sector - 1) * 12) + camp.creatureHealth; 
  uint256 attackTime = creatureHealth/_attackPoints;
  
  attackTime = attackTime > 0 ? attackTime * TIME_CONSTANT : 0;
  
  timestamp = REGEN_TIME/(_healthPoints) + (block.timestamp + attackTime);

}

function _instantKill(uint256 timestamp, uint256 weaponTier, address elfOwner, uint256 id, uint256 instantKillModifier) internal returns(uint256 timestamp_){

  uint16  chance = uint16(_randomize(_rand(), "InstantKill", id)) % 100;
  uint256 killChance = weaponTier == 3 ? 10 : weaponTier == 4 ? 15 : weaponTier == 5 ? 20 : 0;
  
  //Increasing kill chance if the right accessory is equipped
  killChance = killChance + instantKillModifier;       

    if(chance <= killChance){
      
        timestamp_ = block.timestamp + (4 hours);
        emit BloodThirst(elfOwner, id);
    }else{
        timestamp_ = timestamp;
    } 
    //console.log("Instant Kill Chance: " , chance , " Kill Chance: " , killChance);
    emit RollOutcome(id, chance, 10);
    

 }


function _bloodthirst(uint256 _campId, uint256 _sector, uint256 weaponTier, uint256 _level, uint256 _attackPoints, uint256 _healthPoints, uint256 _inventory, bool _useItem) internal view
 
 returns(uint256 rewards, uint256 timestamp, uint256 inventory){
  
  uint256 creatureHealth =  400; 

  rewards = weaponTier == 3 ? 80 ether : weaponTier == 4 ? 95 ether : weaponTier == 5 ? 110 ether : 0;  

  inventory = _inventory;
 
  if(_useItem){

     (inventory, , _attackPoints, _healthPoints, rewards) = _useInventory(_inventory, 1, _attackPoints, _healthPoints, rewards);

  }                            
  
  uint256 attackTime = creatureHealth/_attackPoints;
  
  attackTime = attackTime > 0 ? attackTime * TIME_CONSTANT : 0;
  
  timestamp = REGEN_TIME/(_healthPoints) + (block.timestamp + attackTime);


}

function _rampage(

    DataStructures.Elf memory _elf, 
    GameVariables memory _actions, 
    uint256 _campId, 
    uint256 _id, 
    address elfOwner, 
    bool tryWeapon, 
    bool tryAccessories,
    bool _useItem
    ) internal  
    returns(
            DataStructures.Elf memory elf, 
            GameVariables memory actions
            ){

        Rampages memory rampage = rampages[_campId];  
         
        uint256 rampageCost = uint256(rampage.renCost); //needed to
        rampageCost = rampageCost * (1 ether);
       
        elf = _elf;
        actions = _actions;        

        require(rampage.minLevel <= elf.level, "levelLow");
        require(rampage.maxLevel >= elf.level, "levelHigh"); 
        require(rampage.count > 0, "noSupply");
        //require(bankBalances[elfOwner] >= rampageCost, "notEnoughRen");
        checkRen(elfOwner, rampageCost);
        
       
         rampages[_campId].count = rampage.count - 1;
        _setAccountBalance(elfOwner, rampageCost, true);

        uint256 cooldown = 36 hours;
        uint256 levelsGained = rampage.levelsGained;

        uint256  chance = uint256(_randomize(_rand(), "Rampage", _id)) % 100;

        if(_campId == 6 || _campId == 7){
            //Untamed Ether for DRUID Morphs
           require(elf.sentinelClass == 0, "notDruid");
           if(chance <= 50){
               elf.accessories = 1;
             
           }else{
               elf.accessories = 2;
              
           }
        }

        if(_useItem && elf.inventory == 4){
            //only spiritBand can be used in rampage

            levelsGained = levelsGained * 2;
            elf.inventory = 0;
           

        }     
  
  if(_campId > 2)
  {
            if(tryAccessories){

             //   console.log("here");

                    if(elf.accessories <= 3 && elf.sentinelClass != 0){
                        //enter accessories upgrade loop. Not allowed for >3 (one for ones) or druids

                            //if try accessories is true, try to get accessories
                            if(chance > 0 && chance <= rampage.probDown){
                                //downgrade
                                //dont downgrade if already 0
                                //console.log("downgrade: ", chance);
                                
                                elf.accessories = elf.accessories == 0 ? 0 : elf.accessories - 1;

                            }else if(chance > rampage.probDown && chance <= (rampage.probDown + rampage.probSame)){
                                    //same
                                    // console.log("same: ", chance);
                                  
                                    elf.accessories = elf.accessories;

                            }else if(chance > (rampage.probDown + rampage.probSame) && chance <= 100){
                                    //upgrade
                                   //   console.log("upgrade: ", chance);
                                    elf.accessories = elf.accessories + 1;

                            }

                        //prevent accessories from being upgraded if the elf has >3 accessories        
                        elf.accessories = elf.accessories > 3 ? 3 : elf.accessories;
                    }   

            }else{
                  
                    if(tryWeapon){

                      
                                    if(chance > 0 && chance <= rampage.probDown){
                                        //downgrade
                                        
                                        elf.weaponTier = elf.weaponTier - 1 < 1 ? 1 : elf.weaponTier - 1;       

                                    }else if(chance > rampage.probDown && chance <= (rampage.probDown + rampage.probSame)){
                                        //same
                                       
                                        elf.weaponTier = elf.weaponTier;

                                    }else if(chance > (rampage.probDown + rampage.probSame) && chance <= 100){
                                        //upgrade
                                      
                                        elf.weaponTier = elf.weaponTier + 1;
                                    }

                        elf.weaponTier = elf.weaponTier > 4 ? 4 : elf.weaponTier;
                        elf.primaryWeapon = ((elf.weaponTier - 1) * 3) + ((chance +1) % 3);        

                        }

            }
  }
        
      elf.timestamp = block.timestamp + cooldown;
      elf.level = elf.level + levelsGained;

     emit RollOutcome(_id, chance, 11);
                   
}

function _useInventory(uint256 _inventory, uint256 _level, uint256 _attackPoints, uint256 _healthPoints, uint256 _rewards) internal pure   
    returns(uint256 inventory_, uint256 level_, uint256 attackPoints_, uint256 healthPoints_, uint256 rewards_){

         attackPoints_ = _inventory == 1 ? _attackPoints * 2   : _inventory == 6 ? _attackPoints * 3   : _attackPoints;
         healthPoints_ = _inventory == 2 ? _healthPoints * 2   : _inventory == 5 ? _healthPoints + 200 : _healthPoints; 
         rewards_      = _inventory == 3 ? _rewards * 2        : _rewards;
         level_        = _inventory == 4 ? _level * 2          : _level; 
         
         inventory_ = 0;
}


function _getAbilities(uint256 _attackPoints, uint256 _accesssories, uint256 sentinelClass) 
        private view returns (uint256 attackPoints_, GameVariables memory actions_) {

 attackPoints_ = _attackPoints;
 actions_.healTime = 12 hours;
 actions_.instantKillModifier = 0;      

 _accesssories = ((7 * sentinelClass) + _accesssories) + 1;



        /*console.log("Abilities Check, Ability:", _accesssories);            
        
        console.log("AP BEFORE: ",_attackPoints);
        console.log("heal time BEFORE", actions_.healTime/3600 , " hours");
        console.log("IKM BEFORE:", actions_.instantKillModifier); 
        */

        //if Druid 
        if(_accesssories == 2){
        //Bear
            attackPoints_ = _attackPoints + 30;

        }else if (_accesssories == 3){
        //Liger
            actions_.healTime = 4 hours;        
        
        }else if(_accesssories == 10){
        //if Assassin 3 Crown of Dahagon 
            actions_.instantKillModifier = 15;

        }else if(_accesssories == 11){
        //if Assassin 4 Mechadon's Vizard
            actions_.instantKillModifier = 25;              

        } else if(_accesssories == 17){
        //if Ranger 3 Azrael's Crest
            
            attackPoints_ = _attackPoints * 115/100;
     

        }else if(_accesssories == 18){
        //if Ranger 4 El Machina
            attackPoints_ = _attackPoints * 125/100;             

        }

        if(_accesssories == 6){
            //Druid 1/1
            attackPoints_ = _attackPoints + 20;
            actions_.healTime = 4 hours;        

        }        

        //1 for 1 special abilities
        if(_accesssories == 12 || _accesssories == 13 || _accesssories == 14){
            //Assassin
            actions_.instantKillModifier = 35;
        }else if(_accesssories == 19 || _accesssories == 20 || _accesssories == 21){
            //Ranger
            attackPoints_ = _attackPoints * 135/100;
        }  
        /*
        console.log("AFTER", _accesssories);            
        
        console.log("AP After: ",attackPoints_);
        console.log("heal time After", actions_.healTime/3600 , " hours");
        console.log("IKM After:", actions_.instantKillModifier); 
        */

}


function _exitPassive(uint256 timeDiff, uint256 _level, address _owner) private returns (uint256 level) {
            
            uint256 rewards;

                    if(timeDiff >= 7){
                        rewards = 140 ether;
                    }
                    if(timeDiff >= 14 && timeDiff < 30){
                        rewards = 420 ether;
                    }
                    if(timeDiff >= 30){
                        rewards = 1200 ether;
                    }
                    
                    level = _level + (timeDiff * 1); //one level per day
                    
                    if(level >= 100){
                        level = 100;
                    }
                    
                    _setAccountBalance(_owner, rewards, false);

    }


    function _rollWeapon(uint256 level, uint256 id, uint256 rand, uint256 maxTierWeapon) internal returns (uint256 newWeapon, uint256 newWeaponTier) {
    
        uint256 levelTier = level == 100 ? 5 : uint256((level/20) + 1);
                
                uint256  chance = _randomize(rand, "Weapon", id) % 100;
      
                if(chance > 10 && chance < 80){
        
                             newWeaponTier = levelTier;
        
                        }else if (chance > 80 ){
        
                             newWeaponTier = levelTier + 1 > 4 ? 4 : levelTier + 1;
        
                        }else{
                             newWeaponTier = levelTier - 1 < 1 ? 1 : levelTier - 1;          
                        }
                         
                newWeaponTier = newWeaponTier > maxTierWeapon ? maxTierWeapon : newWeaponTier;

                newWeapon = ((newWeaponTier - 1) * 3) + (rand % 3);   

                 emit RollOutcome(id, chance, 5);           
        
    }

     function _rollitems(uint256 id_) internal returns (uint256 newInventory) {
        
        uint16 morerand = uint16(_randomize(_rand(), "Inventory", id_));
        uint16 diceRoll = uint16(_randomize(_rand(), "Dice", id_));
        
        diceRoll = (diceRoll % 100);
        
        if(diceRoll <= 20){

            newInventory = morerand % 6 + 1;//MAX VALUE 6. Min VALUE: 1
     
        }

        emit RollOutcome(id_, diceRoll, 6);       
         
        
    }



    function _rollCooldown(uint256 _timestamp, uint256 id, uint256 rand) internal returns (uint256 timestamp_) {

        uint16 chance = uint16 (_randomize(rand, "Cooldown", id) % 100); //percentage chance of re-rolling cooldown
        uint256 cooldownLeft = _timestamp - block.timestamp; //time left on cooldown
        timestamp_ = _timestamp; //initialize timestamp to old timestamp

            if(cooldownLeft > 0){
                    
                    if(chance > 10 && chance < 70){
                    
                        timestamp_ = block.timestamp + (cooldownLeft * 2/3);
                    
                    }else if (chance > 70 ){
                    
                        timestamp_ = timestamp_ + 5 minutes;
                    
                    }else{
                            
                        timestamp_ = block.timestamp + (cooldownLeft * 1/2);
                        
                        }
            }

             emit RollOutcome(id, chance, 9);

        return timestamp_;    
                
    }

    /////FUNCTIONS THAT IMPACT STATE ///////////////

    function _buyItem(uint buyItemIndex, address elfOwner) internal returns (uint256 newInventory) {
            //SHOP IS BUYING
            PawnItems memory _pawnItemsBuy = pawnItems[buyItemIndex]; //get item being sold
            require(_pawnItemsBuy.currentInventory < _pawnItemsBuy.maxSupply, "tooHigh");  //check if we will accept
            require(buyItemIndex != 0, "noItem"); //check if we have an item to trade
            require(buyItemIndex != 6, "noItem"); //cannot trade this item           

            uint256 buyPrice = uint256(_pawnItemsBuy.buyPrice); 
            buyPrice = buyPrice * (1 ether); 
 
            _setAccountBalance(elfOwner, buyPrice, false); // pay the seller
            newInventory = 0; // take their item
       
            pawnItems[buyItemIndex].currentInventory = _pawnItemsBuy.currentInventory + 1; //add item to elf pawn stock

                   
        return newInventory;      
        
    }

    

    function _sellItem(uint sellItemIndex, address elfOwner) internal returns (uint256 newInventory) {
               //SHOP IS SELLING
               require(sellItemIndex != 0, "noItem"); //check if we have an item to trade
               PawnItems memory _pawnItems = pawnItems[sellItemIndex];  
         
               uint256 salePrice = uint256(_pawnItems.sellPrice);         
               salePrice = salePrice * (1 ether);

            require(_pawnItems.currentInventory > 0, "noSupply");
            //require(bankBalances[elfOwner] >= salePrice, "notEnoughRen");
             checkRen(elfOwner, salePrice);
            

            _setAccountBalance(elfOwner, salePrice, true); // take ren from buyer
            newInventory = sellItemIndex; //give item to buyer
            
            pawnItems[sellItemIndex].currentInventory = _pawnItems.currentInventory - 1; //reduce our stocks        
                   
        return newInventory;      
        
    }

    function _returnCrusade(uint256 id_, address elfOwner) private {
            onCrusade[id_] = 0;//reset elf on crusade
            DataStructures.Elf memory elf = DataStructures.getElf(sentinels[id_]);
            
            GameVariables memory actions;
            require(isGameActive);
            require(elf.owner == elfOwner, "notYourElf");
            require(elf.timestamp < block.timestamp, "elfBusy");
            require(elf.action == 14, "!onCruasde"); 
           
            elf.action = 15;

            uint256 chance = _randomize(_rand(), "Crusade", id_) % 100;
            uint256 artifactsReceived = 1;

            if(chance < 10){
                artifactsReceived = 2;
            }

            artifacts[elfOwner] = artifactsReceived + artifacts[elfOwner];

            actions.traits = DataStructures.packAttributes(elf.hair, elf.race, elf.accessories);
            actions.class =  DataStructures.packAttributes(elf.sentinelClass, elf.weaponTier, elf.inventory);
                       
            sentinels[id_] = DataStructures._setElf(elf.owner, elf.timestamp, elf.action, elf.healthPoints, elf.attackPoints, elf.primaryWeapon, elf.level, actions.traits, actions.class);
            
            emit Action(elfOwner, 15, id_); 
            emit ArtifactFound(elfOwner, artifactsReceived, id_);
            emit RollOutcome(id_, chance, 15);
    }

    function _mintArtifact (address _owner, uint256 _artifacts) internal {
        //make sure we have enough artifacts to mint
        require(artifacts[_owner] >= _artifacts, "notEnoughArtifacts");
        //remove minted amount from artifacts memory
        artifacts[_owner] = artifacts[_owner] - _artifacts;
        //emit message to dApp to prepare signatures for eth Minting
        emit ArtifactsMinted(_owner, _artifacts, block.timestamp);
        
    }
    
    

    function _setAccountBalance(address _owner, uint256 _amount, bool _subtract) private {
            
            _subtract ? bankBalances[_owner] -= _amount : bankBalances[_owner] += _amount;
            emit BalanceChanged(_owner, _amount, _subtract);
    }


    function _randomize(uint256 ran, string memory dom, uint256 ness) internal pure returns (uint256) {
    return uint256(keccak256(abi.encode(ran,dom,ness)));}

    function _rand() internal view returns (uint256) {
    return uint256(keccak256(abi.encodePacked(msg.sender, block.difficulty, block.timestamp, block.basefee, block.coinbase)));}

/*
█▀█ █░█ █▄▄ █░░ █ █▀▀   █░█ █ █▀▀ █░█░█ █▀
█▀▀ █▄█ █▄█ █▄▄ █ █▄▄   ▀▄▀ █ ██▄ ▀▄▀▄▀ ▄█
*/

    function tokenURI(uint256 _id) external view returns(string memory) {
    return elfmetaDataHandler.getTokenURI(uint16(_id), sentinels[_id]);
    }

    function attributes(uint256 _id) external view returns(uint hair, uint race, uint accessories, uint sentinelClass, uint weaponTier, uint inventory){
    uint256 character = sentinels[_id];

    uint _traits =        uint256(uint8(character>>240));
    uint _class =         uint256(uint8(character>>248));

    hair           = (_traits / 100) % 10;
    race           = (_traits / 10) % 10;
    accessories    = (_traits) % 10;
    sentinelClass  = (_class / 100) % 10;
    weaponTier     = (_class / 10) % 10;
    inventory      = (_class) % 10; 

}

function getSentinel(uint256 _id) external view returns(uint256 sentinel){
    return sentinel = sentinels[_id];
}


/*function getToken(uint256 _id) external view returns(DataStructures.Token memory token){
   
    return DataStructures.getToken(sentinels[_id]);
}*/

function elves(uint256 _id) external view returns(address owner, uint timestamp, uint action, uint healthPoints, uint attackPoints, uint primaryWeapon, uint level) {

    uint256 character = sentinels[_id];

    owner =          address(uint160(uint256(character)));
    timestamp =      uint(uint40(character>>160));
    action =         uint(uint8(character>>200));
    healthPoints =   uint(uint8(character>>208));
    attackPoints =   uint(uint8(character>>216));
    primaryWeapon =  uint(uint8(character>>224));
    level =          uint(uint8(character>>232));   

}

/*

█▀▄▀█ █▀█ █▀▄ █ █▀▀ █ █▀▀ █▀█ █▀
█░▀░█ █▄█ █▄▀ █ █▀░ █ ██▄ █▀▄ ▄█
*/

    /*function isPlayer() internal {    
        uint256 size = 0;
        address acc = msg.sender;
        assembly { size := extcodesize(acc)}
        require((msg.sender == tx.origin && size == 0));
        ketchup = keccak256(abi.encodePacked(acc, block.coinbase));
    }*/

    function onlyOperator() internal view {    
       require(msg.sender == operator || auth[msg.sender] == true);

    }

    function onlyOwner() internal view {    
        require(admin == msg.sender);
    }

    function checkRen(address elfOwner, uint256 amount) internal view {    

        require(bankBalances[elfOwner] >= amount, "notEnoughRen");
        
    }


/*
█▀█ █▀█ █ █▀ █▀▄▀█   █▄▄ █▀█ █ █▀▄ █▀▀ █▀▀
█▀▀ █▀▄ █ ▄█ █░▀░█   █▄█ █▀▄ █ █▄▀ █▄█ ██▄
*/


        function checkIn(uint256[] calldata ids, uint256 renAmount, address owner) public returns (bool) {
            
                onlyOperator();
                require(isTerminalOpen, "terminalClosed");         
                uint256 travelers = ids.length;
                if (travelers > 0) {

                            for (uint256 index = 0; index < ids.length; index++) {  
                                _actions(ids[index], 0, owner, 0, 0, false, false, false, 0);
                                emit CheckIn(owner, block.timestamp, ids[index], sentinels[ids[index]]);
                                sentinels[ids[index]] = 0; //scramble their bwainz
                            }
                        
                }

                    if (renAmount > 0) {

                            if(bankBalances[owner] - renAmount >= 0) {                      
                                _setAccountBalance(owner, renAmount, true);
                                emit RenTransferOut(owner,block.timestamp,renAmount);
                            }
                    }
            

        }

        function checkOutRen(uint256[] calldata renAmounts, bytes[] memory renSignatures, uint256[] calldata timestamps, address[] calldata owners) public returns (bool) {
        
        onlyOperator();
            require(isTerminalOpen, "terminalClosed"); 
            

                for(uint i = 0; i < owners.length; i++){
                    require(usedRenSignatures[renSignatures[i]] == 0, "Signature already used");   
                    require(_isSignedByValidator(encodeRenForSignature(renAmounts[i], owners[i], timestamps[i]),renSignatures[i]), "incorrect signature");
                    usedRenSignatures[renSignatures[i]] = 1;
                    
                    bankBalances[owners[i]] += renAmounts[i];     
                    emit RenTransferedIn(owners[i], renAmounts[i]);    
                }            
            
            }
            


        function encodeRenForSignature(uint256 renAmount, address owner, uint256 timestamp) public pure returns (bytes32) {
            return keccak256(
                    abi.encodePacked("\x19Ethereum Signed Message:\n32", 
                        keccak256(
                                abi.encodePacked(renAmount, owner, timestamp))
                                )
                            );
        }  
        
        function _isSignedByValidator(bytes32 _hash, bytes memory _signature) private view returns (bool) {
            
            bytes32 r;
            bytes32 s;
            uint8 v;
                assembly {
                        r := mload(add(_signature, 0x20))
                        s := mload(add(_signature, 0x40))
                        v := byte(0, mload(add(_signature, 0x60)))
                    }
                
                    address signer = ecrecover(_hash, v, r, s);
                    return signer == polyValidator;
        
        }


    function prismBridge(uint256[] calldata ids, uint256[] calldata sentinel) external {
        require (msg.sender == operator || admin == msg.sender || auth[msg.sender] == true, "not allowed");
        require(isTerminalOpen);
        
        for(uint i = 0; i < ids.length; i++){

            DataStructures.Elf memory elf = DataStructures.getElf(sentinels[ids[i]]);            
            require(elf.owner == address(0), "Already in Polygon");
            
            sentinels[ids[i]] = sentinel[i];
            
            emit ElfTransferedIn(ids[i], sentinel[i]);

        }       
        
    }

/*
▄▀█ █▀▄ █▀▄▀█ █ █▄░█   █▀▀ █░█ █▄░█ █▀▀ ▀█▀ █ █▀█ █▄░█ █▀
█▀█ █▄▀ █░▀░█ █ █░▀█   █▀░ █▄█ █░▀█ █▄▄ ░█░ █ █▄█ █░▀█ ▄█
*/
function addScrolls(uint256[] calldata qty, address[] memory owners) external {
        onlyOwner();
        for(uint256 i = 0; i < qty.length; i++) {
            if(qty[i] > 0) {
                 scrolls[owners[i]] = qty[i];
            }
        }
}

function addCamp(uint256 id, uint16 baseRewards_, uint16 creatureCount_, uint16 expPoints_, uint16 creatureHealth_, uint16 minLevel_, uint16 maxLevel_) external      
    {
        onlyOwner();
        
        Camps memory newCamp = Camps({
            baseRewards:    baseRewards_, 
            creatureCount:  creatureCount_, 
            expPoints:      expPoints_,
            creatureHealth: creatureHealth_, 
            minLevel:       minLevel_,
            campMaxLevel:   maxLevel_
            });
        
        camps[id] = newCamp;
        
        emit AddCamp(id, baseRewards_, creatureCount_, expPoints_, creatureHealth_, minLevel_);
    }


function addRampage(uint256 id, uint16 probDown_, uint16 probSame_, uint16 propUp_, uint16 levelsGained_, uint16 minLevel_, uint16 maxLevel_, uint16 renCost_, uint16 count_) external      
    {
        onlyOwner();

            Rampages memory newRampage = Rampages({
                
                probDown: probDown_, 
                probSame: probSame_, 
                propUp: propUp_, 
                levelsGained: levelsGained_, 
                minLevel: minLevel_, 
                maxLevel: maxLevel_, 
                renCost: renCost_, 
                count: count_
                
                }); 
            
        
            rampages[id] = newRampage;        
       
    }

function addPawnItem(uint256 id, uint16 buyPrice_, uint16 sellPrice_, uint16 maxSupply_, uint16 currentInventory_) external      
    {
        onlyOwner();

            PawnItems memory newPawnItem = PawnItems({
                
                buyPrice: buyPrice_, 
                sellPrice: sellPrice_, 
                maxSupply: maxSupply_, 
                currentInventory: currentInventory_
                
                }); 
            
        
            pawnItems[id] = newPawnItem;        
       
    }


   function setAccountBalance(address _owner, uint256 _amount) public {                
        onlyOwner();
        bankBalances[_owner] += _amount;
    }

    function setElfManually(uint id, uint8 _primaryWeapon, uint8 _weaponTier, uint8 _attackPoints, uint8 _healthPoints, uint8 _level, uint8 _inventory, uint8 _race, uint8 _class, uint8 _accessories, address _elfOwner) external {
        onlyOwner();
        DataStructures.Elf memory elf = DataStructures.getElf(sentinels[id]);
        GameVariables memory actions;

        elf.owner           = _elfOwner;
        elf.timestamp       = elf.timestamp;
        elf.action          = elf.action;
        elf.healthPoints    = _healthPoints;
        elf.attackPoints    = _attackPoints;
        elf.primaryWeapon   = _primaryWeapon;
        elf.level           = _level;
        elf.weaponTier      = _weaponTier;
        elf.inventory       = _inventory;
        elf.race            = _race;
        elf.sentinelClass   = _class;
        elf.accessories     = _accessories;

        actions.traits = DataStructures.packAttributes(elf.hair, elf.race, elf.accessories);
        actions.class =  DataStructures.packAttributes(elf.sentinelClass, elf.weaponTier, elf.inventory);
                       
        sentinels[id] = DataStructures._setElf(elf.owner, elf.timestamp, elf.action, elf.healthPoints, elf.attackPoints, elf.primaryWeapon, elf.level, actions.traits, actions.class);
        
    }

        function changeElfAccessory(uint8 accessoryIndex, uint id) external {
       
        onlyOwner();
        DataStructures.Elf memory elf = DataStructures.getElf(sentinels[id]);
        GameVariables memory actions;
        require(accessoryIndex <=7, "outOfRange");

        elf.accessories = accessoryIndex;
       
        actions.traits = DataStructures.packAttributes(elf.hair, elf.race, elf.accessories);
        actions.class =  DataStructures.packAttributes(elf.sentinelClass, elf.weaponTier, elf.inventory);
                       
        sentinels[id] = DataStructures._setElf(elf.owner, elf.timestamp, elf.action, elf.healthPoints, elf.attackPoints, elf.primaryWeapon, elf.level, actions.traits, actions.class);
        
    }

    /* // COMMENTED OUT TO MAKE SPACE FOR NEW FUNCTIONALITY

    function changeElfOwner(address elfOwner, uint id) external {
        onlyOwner();
        DataStructures.Elf memory elf = DataStructures.getElf(sentinels[id]);
        GameVariables memory actions;

        elf.owner           = elfOwner;
       
        actions.traits = DataStructures.packAttributes(elf.hair, elf.race, elf.accessories);
        actions.class =  DataStructures.packAttributes(elf.sentinelClass, elf.weaponTier, elf.inventory);
                       
        sentinels[id] = DataStructures._setElf(elf.owner, elf.timestamp, elf.action, elf.healthPoints, elf.attackPoints, elf.primaryWeapon, elf.level, actions.traits, actions.class);
        
    }



    function changeElfLevel(uint8 level, uint id) external {
       
        onlyOwner();
        DataStructures.Elf memory elf = DataStructures.getElf(sentinels[id]);
        GameVariables memory actions;
        require(level <=255, "level out of range");

        elf.level = level;
       
        actions.traits = DataStructures.packAttributes(elf.hair, elf.race, elf.accessories);
        actions.class =  DataStructures.packAttributes(elf.sentinelClass, elf.weaponTier, elf.inventory);
                       
        sentinels[id] = DataStructures._setElf(elf.owner, elf.timestamp, elf.action, elf.healthPoints, elf.attackPoints, elf.primaryWeapon, elf.level, actions.traits, actions.class);
        
    }

    function changeElfItem(uint8 inventory, uint id) external {
       
        onlyOwner();
        DataStructures.Elf memory elf = DataStructures.getElf(sentinels[id]);
        GameVariables memory actions;
        require(inventory <=6, "item index out of range");

        elf.inventory = inventory;
       
        actions.traits = DataStructures.packAttributes(elf.hair, elf.race, elf.accessories);
        actions.class =  DataStructures.packAttributes(elf.sentinelClass, elf.weaponTier, elf.inventory);
                       
        sentinels[id] = DataStructures._setElf(elf.owner, elf.timestamp, elf.action, elf.healthPoints, elf.attackPoints, elf.primaryWeapon, elf.level, actions.traits, actions.class);
        
    }

    function changeElfWeapons(uint id, uint8 _primaryWeapon, uint8 _weaponTier, uint8 _attackPoints) external {
        onlyOwner();
        DataStructures.Elf memory elf = DataStructures.getElf(sentinels[id]);
        GameVariables memory actions;

        elf.attackPoints    = _attackPoints;
        elf.primaryWeapon   = _primaryWeapon;
        elf.weaponTier      = _weaponTier;
        
        actions.traits = DataStructures.packAttributes(elf.hair, elf.race, elf.accessories);
        actions.class =  DataStructures.packAttributes(elf.sentinelClass, elf.weaponTier, elf.inventory);
                       
        sentinels[id] = DataStructures._setElf(elf.owner, elf.timestamp, elf.action, elf.healthPoints, elf.attackPoints, elf.primaryWeapon, elf.level, actions.traits, actions.class);
        
    }

    */
  

    function modifyElfDNA(uint256[] calldata ids, uint256[] calldata sentinel) external {
       onlyOwner();  
        
        for(uint i = 0; i < ids.length; i++){
            
            sentinels[ids[i]] = sentinel[i];
            
            emit ElfTransferedIn(ids[i], sentinel[i]);

        }        
        
    } 

      function setAuth(address[] calldata adds_, bool status) public {
       onlyOwner();
       
        for (uint256 index = 0; index < adds_.length; index++) {
            auth[adds_[index]] = status;
        }
    }

    
    function setAddresses(address _inventory, address _operator)  public {
       onlyOwner();
       elfmetaDataHandler   = IElfMetaDataHandler(_inventory);
       operator             = _operator;
    }

    function setValidator(address _validator)  public {
       onlyOwner();
       polyValidator = _validator;
    }     
    /*
        function flipActiveStatus() external {
        onlyOwner();
        isGameActive = !isGameActive;
        }


        function flipTerminal() external {
        onlyOwner();
        isTerminalOpen = !isTerminalOpen;
        }

    */
    

}


