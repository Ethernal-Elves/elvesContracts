// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.7;
//import "hardhat/console.sol"; ///REMOVE BEFORE DEPLOYMENT
//v 1.0.3

library EldersDataStructures {

/////////////DATA STRUCTURES///////////////////////////////
    struct EldersMeta {
            uint256 strength;
            uint256 agility;
            uint256 intellegence;
            uint256 healthPoints;
            uint256 attackPoints; 
            uint256 mana;
            uint256 primaryWeapon; 
            uint256 secondaryWeapon; 
            uint256 armor; 
            uint256 primaryTrait;
            uint256 level;
            uint256 head;
            uint256 race;             
            uint256 body;  
            uint256 elderClass;                         
    }





    
////////////////////////////////////////////////////

function getElder(uint256 _elder) internal pure returns(EldersMeta memory elder) {

    elder.attackPoints =     uint256(uint8(_elder>>160));
    elder.healthPoints =     uint256(uint8(_elder>>168));
    elder.mana =       uint256(uint8(_elder>>176));
    elder.strength =            uint256(uint8(_elder>>184));
    elder.agility =            uint256(uint8(_elder>>192));
    elder.primaryWeapon =           uint256(uint8(_elder>>200));
    elder.secondaryWeapon =             uint256(uint8(_elder>>208));
    elder.elderClass =            uint256(uint8(_elder>>216));
    elder.weaponTier =            uint256(uint8(_elder>>224));
    elder.inventory =            uint256(uint8(_elder>>232));   

} 

function getItem(uint256 _item) internal pure returns(EldersInventory memory item) {

    item.source =           address(uint160(uint256(_item)));
    item.attackPoints =     uint256(uint8(_item>>160));
    item.healthPoints =     uint256(uint8(_item>>168));
    item.manaPoints =       uint256(uint8(_item>>176));
    item.class =            uint256(uint8(_item>>184));
    item.layer =            uint256(uint8(_item>>192));
    item.aether =           uint256(uint8(_item>>200));
    item.iron =             uint256(uint8(_item>>208));
    item.terra =            uint256(uint8(_item>>216));
    item.frost =            uint256(uint8(_item>>224));
    item.magma =            uint256(uint8(_item>>232));   

} 

function setItem(
                address source,
                uint256 attackPoints,
                uint256 healthPoints,
                uint256 manaPoints,
                uint256 layer,
                uint256 class,
                uint256 aether,
                uint256 iron,
                uint256 terra,
                uint256 frost,
                uint256 magma  )

    internal pure returns (uint256 item) {

    item = uint256(uint160(address(source)));
    
    item |= attackPoints<<160;
    item |= healthPoints<<168;
    item |= manaPoints<<176;
    item |= layer<<184;
    item |= class<<192;
    item |= aether<<200;
    item |= iron<<208;
    item |= terra<<216;
    item |= frost<<224;
    item |= magma<<232;
    
    return item;
}
/////////////////////////////////////////////////////
/*
function getElder(uint256 character) internal pure returns(EldersMeta memory elder) {
    uint256 strength;
            uint256 agility;
            uint256 intellegence;
            uint256 maxMana;
            uint256 mana;
            uint256 healthPoints;
            uint256 health;
            uint256 attackPoints; 
            uint256 primaryWeapon; 
            uint256 secondaryWeapon; 
            uint256 accessories; 
            uint256 level;
            uint256 rank;
            uint256 hair;
            uint256 race;             
            uint256 elderClass; 
            uint256 weaponTier; 
            uint256 inventory; 

  
    elder.healthPoints =       uint256(uint8(character>>208));
    elder.attackPoints =   uint256(uint8(character>>216));
    elder.primaryWeapon =  uint256(uint8(character>>224));
    elder.level    =       uint256(uint8(character>>232));
    elder.hair           = (uint256(uint8(character>>240)) / 100) % 10;
    elder.race           = (uint256(uint8(character>>240)) / 10) % 10;
    elder.accessories    = (uint256(uint8(character>>240))) % 10;
    elder.sentinelClass  = (uint256(uint8(character>>248)) / 100) % 10;
    elder.weaponTier     = (uint256(uint8(character>>248)) / 10) % 10;
    elder.inventory      = (uint256(uint8(character>>248))) % 10; 

} 

/*

function getElderOwner(uint256 character) internal pure returns(EldersMeta memory _elf) {
   
    _elf.owner =          address(uint160(uint256(character)));
    _elf.timestamp =      uint256(uint40(character>>160));
    _elf.action =         uint256(uint8(character>>200));
    _elf.healthPoints =       uint256(uint8(character>>208));
    _elf.attackPoints =   uint256(uint8(character>>216));
    _elf.primaryWeapon =  uint256(uint8(character>>224));
    _elf.level    =       uint256(uint8(character>>232));
    _elf.hair           = (uint256(uint8(character>>240)) / 100) % 10;
    _elf.race           = (uint256(uint8(character>>240)) / 10) % 10;
    _elf.accessories    = (uint256(uint8(character>>240))) % 10;
    _elf.sentinelClass  = (uint256(uint8(character>>248)) / 100) % 10;
    _elf.weaponTier     = (uint256(uint8(character>>248)) / 10) % 10;
    _elf.inventory      = (uint256(uint8(character>>248))) % 10; 

} 

function getToken(uint256 character) internal pure returns(EldersMeta memory token) {
   
    token.owner          = address(uint160(uint256(character)));
    token.timestamp      = uint256(uint40(character>>160));
    token.action         = (uint8(character>>200));
    token.healthPoints   = (uint8(character>>208));
    token.attackPoints   = (uint8(character>>216));
    token.primaryWeapon  = (uint8(character>>224));
    token.level          = (uint8(character>>232));
    token.hair           = ((uint8(character>>240)) / 100) % 10; //MAX 3
    token.race           = ((uint8(character>>240)) / 10) % 10; //Max6
    token.accessories    = ((uint8(character>>240))) % 10; //Max7
    token.sentinelClass  = ((uint8(character>>248)) / 100) % 10; //MAX 3
    token.weaponTier     = ((uint8(character>>248)) / 10) % 10; //MAX 6
    token.inventory      = ((uint8(character>>248))) % 10; //MAX 7

    token.hair = (token.sentinelClass * 3) + (token.hair + 1);
    token.race = (token.sentinelClass * 4) + (token.race + 1);
    token.primaryWeapon = token.primaryWeapon == 69 ? 69 : (token.sentinelClass * 15) + (token.primaryWeapon + 1);
    token.accessories = (token.sentinelClass * 7) + (token.accessories + 1);

}

function _setElder(
                address owner, uint256 timestamp, uint256 action, uint256 healthPoints, 
                uint256 attackPoints, uint256 primaryWeapon, 
                uint256 level, uint256 traits, uint256 class )

    internal pure returns (uint256 sentinel) {

    uint256 character = uint256(uint160(address(owner)));
    
    character |= timestamp<<160;
    character |= action<<200;
    character |= healthPoints<<208;
    character |= attackPoints<<216;
    character |= primaryWeapon<<224;
    character |= level<<232;
    character |= traits<<240;
    character |= class<<248;
    
    return character;
}



function _randomize(uint256 ran, string memory dom, uint256 ness) internal pure returns (uint256) {
    return uint256(keccak256(abi.encode(ran,dom,ness)));}

*/

}

