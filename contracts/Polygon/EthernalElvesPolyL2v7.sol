// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.7;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "./PolyElvesERC721.sol"; 
import "./../DataStructures.sol";
import "./../Interfaces.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
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
// Version 6.0.0

contract PolyEthernalElvesV7 is PolyERC721 {

    function name() external pure returns (string memory) { return "Polygon Ethernal Elves"; }
    function symbol() external pure returns (string memory) { return "pELV"; }
       
    
    using DataStructures for DataStructures.Elf;    

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

    //CRUSADER NO REGRET// 
    ///////////////////////////////////////////////////////////////////////////////////////////
    mapping(address => uint256) public scrolls; //memory slot for scrolls to go on crusades////
    mapping(address => uint256) public artifacts; //memory slot for artifact mint           ///
    mapping(uint256 => uint256) public onCrusade;                                           /// 
    ///////////////////////////////////////////////////////////////////////////////////////////    
    mapping(address => uint256) public moonBalances;         
    //NewDataSlots from this deployment///
    uint256 public CREATURE_HEALTH; 
    uint256 public scrollsForSale;
    uint256 public scrollsForSalePrice;
    ///////////////////////////////////////////////////////////////////////////////////////////    
    mapping(uint256 => uint256) public elders; //memory slot for Elfs
    mapping(address => uint256) public eldersOwner; //memory slot for scrolls to go on crusades////
  

/*
█▀▀ █░█ █▀▀ █▄░█ ▀█▀ █▀
██▄ ▀▄▀ ██▄ █░▀█ ░█░ ▄█
*/

    event Action(address indexed from, uint256 indexed action, uint256 indexed tokenId);         
    event BalanceChanged(address indexed owner, uint256 indexed amount, bool indexed subtract);
    event MoonBalanceChanged(address indexed owner, uint256 indexed amount, bool indexed subtract);
    event Campaigns(address indexed owner, uint256 amount, uint256 indexed campaign, uint256 sector, uint256 indexed tokenId);
    
    event BloodThirst(address indexed owner, uint256 indexed tokenId); 
    event RollOutcome(uint256 indexed tokenId, uint256 roll, uint256 action);
    event ArtifactFound(address indexed from, uint256 artifacts, uint256 indexed tokenId);
    

    event CheckIn(address indexed from, uint256 timestamp, uint256 indexed tokenId, uint256 indexed sentinel);      
    event RenTransferOut(address indexed from, uint256 timestamp, uint256 indexed renAmount);   
    event ElfTransferedIn(uint256 indexed tokenId, uint256 sentinel); 
    event RenTransferedIn(address indexed from, uint256 renAmount); 
    event ArtifactOut(address indexed from, uint256 timestamp, uint256 indexed amount);   
    event ScrollsBought(address indexed from, uint256 timestamp, uint256 indexed amount);   



/*
█▀▀ ▄▀█ █▀▄▀█ █▀▀ █▀█ █░░ ▄▀█ █▄█
█▄█ █▀█ █░▀░█ ██▄ █▀▀ █▄▄ █▀█ ░█░
*/


    //////////FOR OFFCHAIN USE ONLY/////////////
    function generateSentinelDna(
                address owner, uint256 timestamp, uint256 action, uint256 healthPoints, 
                uint256 attackPoints, uint256 primaryWeapon, uint256 level, 
                uint256 traits, uint256 class)

    external pure returns (uint256 sentinel) {

     sentinel = DataStructures._setElf(owner, timestamp, action, healthPoints, attackPoints, primaryWeapon, level, traits, class);
    
    return sentinel;
}


function decodeSentinelDna(uint256 character) external view returns(DataStructures.Elf memory elf) {
      elf = DataStructures.getElf(character);
} 

/////////////////////////////////////////////////
    


    function _setAccountBalance(address _owner, uint256 _amount, bool _subtract, uint256 _index) private {
            
            if(_index == 0){
                //0 = REN
                _subtract ? bankBalances[_owner] -= _amount : bankBalances[_owner] += _amount;
                emit BalanceChanged(_owner, _amount, _subtract);

            }else if(_index == 1){
                //1 = MOON
                _subtract ? moonBalances[_owner] -= _amount : bankBalances[_owner] += _amount;
                emit MoonBalanceChanged(_owner, _amount, _subtract);

            }
            
    }


    function _randomize(uint256 ran, string memory dom, uint256 ness) internal pure returns (uint256) {
    return uint256(keccak256(abi.encode(ran,dom,ness)));}

    function _rand() internal view returns (uint256) {
    return uint256(keccak256(abi.encodePacked(msg.sender, block.difficulty, block.timestamp, block.basefee, block.coinbase)));}

/*
█▀█ █░█ █▄▄ █░░ █ █▀▀   █░█ █ █▀▀ █░█░█ █▀
█▀▀ █▄█ █▄█ █▄▄ █ █▄▄   ▀▄▀ █ ██▄ ▀▄▀▄▀ ▄█
*/

  

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

    function onlyOperator() internal view {    
       require(msg.sender == operator || auth[msg.sender] == true);

    }

    function onlyOwner() internal view {    
        require(admin == msg.sender);
    }

    function checkRen(address elfOwner, uint256 amount) internal view {    
        require(bankBalances[elfOwner] >= amount, "notEnoughRen");        
    }
    
    function checkMoon(address elfOwner, uint256 amount) internal view {    
        require(moonBalances[elfOwner] >= amount, "notEnoughMoon");        
    }
    function checkArtifacts(address elfOwner, uint256 amount) internal view {    
        require(artifacts[elfOwner] >= amount, "notEnoughArtifacts");        
    }


/*
▄▀█ █▀▄ █▀▄▀█ █ █▄░█   █▀▀ █░█ █▄░█ █▀▀ ▀█▀ █ █▀█ █▄░█ █▀
█▀█ █▄▀ █░▀░█ █ █░▀█   █▀░ █▄█ █░▀█ █▄▄ ░█░ █ █▄█ █░▀█ ▄█
*/

function addScrollsForSale(uint256 qty, uint256 price) external {
        onlyOwner();
        scrollsForSale = qty;
        scrollsForSalePrice = price;
}

function setCreatureHealth(uint256 creatureHealth) external {
        onlyOwner();
        CREATURE_HEALTH = creatureHealth;
}

function adminSetAccountBalance(address _owner, uint256 _amount) public {                
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
    
    function setAddresses(address _inventory, address _operator)  public {
       onlyOwner();
       elfmetaDataHandler   = IElfMetaDataHandler(_inventory);
       operator             = _operator;
    }


    function setValidator(address _validator)  public {
       onlyOwner();
       polyValidator = _validator;
    }
    
    function setAuth(address[] calldata adds_, bool status) public {
       onlyOwner();
       
        for (uint256 index = 0; index < adds_.length; index++) {
            auth[adds_[index]] = status;
        }
    }     
    
    //Bridge

    function prismBridge(uint256[] calldata ids, uint256[] calldata sentinel, address owner) external {
      onlyOperator();
        
        for(uint i = 0; i < ids.length; i++){           
            
            DataStructures.Elf memory elf = DataStructures.getElf(sentinels[ids[i]]);            
            require(elf.owner == address(0), "Already in Polygon");
            
            sentinels[ids[i]] = sentinel[i];
            emit ElfTransferedIn(ids[i], sentinel[i]);
        }
        //emit event to        sentinelTransfers ids 
        
    }

    function exitElf(uint256[] calldata ids, address owner) external {
      onlyOperator();
      uint256 action = 0;
          
        for(uint i = 0; i < ids.length; i++){
           
           emit CheckIn(owner, block.timestamp, ids[i], sentinels[ids[i]]);
           sentinels[ids[i]] = 0; //scramble their bwainz.. muahaha.
         
        }        
         
    } 

     
    function setAccountBalance(address _owner, uint256 _amount, bool _subtract, uint256 _index) external {
            
            onlyOperator();
            if(_subtract){
               
                    if(_index == 0){
                        checkRen(_owner, _amount);
                        bankBalances[_owner] -= _amount;                     
                        emit RenTransferOut(_owner,block.timestamp,_amount);

                    }else if (_index == 1){
                        checkMoon(_owner, _amount);
                        moonBalances[_owner] -= _amount; 

                    }else if (_index == 2){
                        checkArtifacts(_owner, _amount);
                        artifacts[_owner] -= _amount; 
                        emit ArtifactOut(_owner,block.timestamp,_amount);
                    }
                    

            }else{
                
                    if(_index == 0){
                        //0 = REN
                        bankBalances[_owner] += _amount;                       
                        emit RenTransferedIn(_owner, _amount);        

                    }else if(_index == 1){
                        //1 = Moon
                        moonBalances[_owner] += _amount;
                        
                    }else if(_index == 2){
                        //2 = Artifacts
                        artifacts[_owner] += _amount;
                        
                    }   

            }

            
            
    }

    function tokenURI(uint256 _id) external view returns(string memory) {
//    return elfmetaDataHandler.getTokenURI(uint16(_id), sentinels[_id]);
     string memory tokenURI = 'https://ee-metadata-api.herokuapp.com/api/sentinels/';
      return string(abi.encodePacked(tokenURI, Strings.toString(_id)));

    }

    function getAllAccountBalances(address _owner) external returns (uint256 ren_, uint256 moon_, uint256 artifacts_, uint256 scrolls_) {

           ren_ = bankBalances[_owner];                
           moon_ = moonBalances[_owner];                
           artifacts_ = artifacts[_owner];
           scrolls_ = scrolls[_owner];

    }

    function mintArtifacts (address _owner, uint256 _artifacts) external {
        onlyOperator();
        checkArtifacts(_owner, _artifacts);
        artifacts[_owner] = artifacts[_owner] - _artifacts;
        emit ArtifactOut(_owner,block.timestamp,_artifacts);
    }

    function buyScrolls(uint256 qty, address owner) external {
        onlyOperator();
        require(scrollsForSale >= qty, "notEnoughScrolls");

        scrolls[owner] = qty + scrolls[owner];
        
        scrollsForSale = scrollsForSale - qty;

        emit ScrollsBought(owner, block.timestamp, qty);  
       
    }



}


