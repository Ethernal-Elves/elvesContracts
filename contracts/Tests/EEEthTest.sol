// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.7;

import "../EthernalElvesV6.sol";
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

contract EETest is EthernalElvesV6 {
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


 
   function initialize() public {
    
       require(!initialized, "Already initialized");
       admin                = msg.sender;   
       maxSupply            = 6666; 
       INIT_SUPPLY          = 3300; 
       initialized          = true;
       price                = .088 ether;  
       _remaining           = [250,660,2500]; //[200, 600, 2500]; //this is the supply of each whitelist role
       validator            = 0x80861814a8775de20F9506CF41932E95f80f7035;
       
    }

      function setInitialAddress(address _ren, address _inventory, address _bridge) public {

              ren                  = IERC20Lite(_ren); 
              elfmetaDataHandler   = IElfMetaDataHandler(_inventory);
              terminus             = _bridge;       


      }


}