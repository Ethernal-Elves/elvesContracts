// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.7;

import "../Polygon/EthernalElvesPolyL2v6.sol";
import "hardhat/console.sol";

contract EETestPolygon is PolyEthernalElvesV6 {
/////////THIS CODE IS NOT TO BE USED IN PROD
bool private initialized;
function mint(uint8 _level, uint8 _accessories, uint8 _race, uint8 _class, uint8 _item, uint8 _weapon, uint8 _weaponTier) public returns (uint16 id) {
        
            uint256 rand = _rand();
                      
            {        
                DataStructures.Elf memory elf;
                id = uint16(totalSupply + 1);   
                        
                elf.owner = msg.sender;
                elf.timestamp = block.timestamp;
                
                elf.action = 0; 
                
                elf.weaponTier = _weaponTier;
                
                elf.inventory = _item;
                
                elf.primaryWeapon = _weapon;

                elf.level = _level;

                elf.sentinelClass = _class;
               
                elf.race = _race;

                elf.hair = elf.race == 3 ? 0 : uint16(_randomize(rand, "Hair", id)) % 3;            

                elf.accessories = _accessories;

                uint256 _traits = DataStructures.packAttributes(elf.hair, elf.race, elf.accessories);
                uint256 _class =  DataStructures.packAttributes(elf.sentinelClass, elf.weaponTier, elf.inventory);
                
                elf.healthPoints = DataStructures.calcHealthPoints(elf.sentinelClass, elf.level);
                elf.attackPoints = DataStructures.calcAttackPoints(elf.sentinelClass, elf.weaponTier); 

            sentinels[id] = DataStructures._setElf(elf.owner, elf.timestamp, elf.action, elf.healthPoints, elf.attackPoints, elf.primaryWeapon, elf.level, _traits, _class);
            
            }
                
            _mint(msg.sender, id);           

        }

           function mintZombie(uint256 qty) external {
              for(uint i = 1; i <= qty; i++){        
                    _mint(address(this), i);     
              }              
    }    

    function initialize() public {
    
       require(!initialized, "Already initialized");
       admin                = msg.sender;   
       initialized          = true;
       operator             = 0x5707FF21A520BEEBcCdAD13dF292576e7FbE4cB4; 
       elfmetaDataHandler   = IElfMetaDataHandler(	0x5707FF21A520BEEBcCdAD13dF292576e7FbE4cB4);
       auth[0xe2ae5460b5796e2800C064Fae2A4caB347A1447B] = true;
       auth[0x1653FeA0EAb46A843239f3993EFFc4Cc0B6706DE] = true; 
       camps[1] = Camps({baseRewards: 10, creatureCount: 1000, creatureHealth: 120,  expPoints:6,   minLevel:1, campMaxLevel:100});
       CREATURE_HEALTH = 420; 
       MAX_LEVEL = 100;
       TIME_CONSTANT = 1 hours; 
       REGEN_TIME = 300 hours; 
       isGameActive = true;
       isTerminalOpen = true;

    }

    function setAllBalances(address _owner, uint256 _ren, uint256 _moon, uint256 _scrolls, uint256 _artifacts) external {
        onlyOwner();
        bankBalances[_owner] = _ren;
        moonBalances[_owner] = _moon;          
        scrolls[_owner] = _scrolls;
        artifacts[_owner] = _artifacts;
    }
  
}