// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.7;

import "../Polygon/EthernalElvesPolyL2v5.sol";
import "hardhat/console.sol";

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
// Version 4.0.0
// Release notes: Adding Rampage and new abilities based on accessories 

contract EETestPolygon is PolyEthernalElvesV5 {
 bool private initialized;
/////////THIS CODE IS NOT TO BE USED IN PROD
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
       operator             = 0xa2B877EC3234F50C33Ff7d0605F7591053d06E31; 
       elfmetaDataHandler   = IElfMetaDataHandler(0x3cF1630393BFd1D9fF52bD822fE88714FC81467E);

       camps[1] = Camps({baseRewards: 10, creatureCount: 1000, creatureHealth: 120,  expPoints:6,   minLevel:1, campMaxLevel:100});

       MAX_LEVEL = 100;
       TIME_CONSTANT = 1 hours; 
       REGEN_TIME = 300 hours; 

    }

     function flipActiveStatus() external {
        onlyOwner();
        isGameActive = !isGameActive;
        }


        function flipTerminal() external {
        onlyOwner();
        isTerminalOpen = !isTerminalOpen;
        }   


            function setAllBalances(address _owner, uint256 _ren, uint256 _moon, uint256 _scrolls, uint256 _artifacts) external {

            
            bankBalances[_owner] = _ren;
            moonBalances[_owner] = _moon;          
            scrolls[_owner] = _scrolls;
            artifacts[_owner] = _artifacts;
            
    }

}