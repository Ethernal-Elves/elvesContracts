// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.12;

import "hardhat/console.sol";
import "./ERC721.sol"; 
import "./EldersDataStructures.sol";
import "./Interfaces.sol";

contract Elders is ERC721 {

    function name() external pure returns (string memory) { return "EthernalElves Elders"; }
    function symbol() external pure returns (string memory) { return "ELD"; }
       
    using EldersDataStructures for EldersDataStructures.EldersMeta;

    IERC1155Lite public artifacts;
    IEldersMetaDataHandler public eldermetaDataHandler;

    bool private initialized;
    bool public isMintOpen;
    bool public isRevealed;    
    address public validator;   
    uint256 public pvConstant;
    uint256[3][6] public baseValues;
    uint256[3][6] public uniques;
    uint256 uniquesCount;
    bytes32 ketchup;

    mapping(uint256 => uint256) public eldersMeta; //memory slot for Elder Metadata
    mapping(uint256 => address) public elderOwner; //memory slot for Owners, Timestamp and Actions
    mapping(address => bool)    public auth; //memory slot for Authorized addresses

    function initialize() public {
    
       require(!initialized, "Already initialized");
       admin                = msg.sender;   
       maxSupply            = 2222; 
       initialized          = true;
       isMintOpen           = true;
       validator            = 0x80861814a8775de20F9506CF41932E95f80f7035;
       pvConstant           = 200;
       baseValues[0]        = [15,20,25];
       baseValues[1]        = [15,20,25];
       baseValues[2]        = [20,25,15];
       baseValues[3]        = [20,25,15];
       baseValues[4]        = [25,15,20];
       baseValues[5]        = [25,15,20];
       isRevealed           = true;

    }


    function mint(uint256 quantity) external payable  returns (uint256 id) {
    
        isPlayer();
        require(isMintOpen, "Minting is closed");
        uint256 price = totalSupply <= 1800 ? 7 : 11;
        uint256 totalCost = price * quantity;

        require(artifacts.balanceOf(msg.sender, 1) >= totalCost, "Not Enough Artifacts");
        require(maxSupply - quantity >= 0, "No Elders Left");        
        
        artifacts.burn(msg.sender, 1, totalCost);

        return _mintElder(msg.sender, quantity);

    }


     function _mintElder(address _to, uint256 qty) private returns (uint16 id) {
        ////
        for(uint256 i = 0; i < qty; i++) {
        
        uint256 rand = _rand() + i; 
        uint256 uniqueChance = rand % 10000;

        EldersDataStructures.EldersMeta memory elders;        
        
        id = uint16(totalSupply + 1);           

            elders.elderClass           = uint256(_randomize(rand, "Class", id)) % 6;
            elders.strength             = baseValues[elders.elderClass][0];
            elders.agility              = baseValues[elders.elderClass][1];
            elders.intellegence         = baseValues[elders.elderClass][2];  

            elders.healthPoints         = pvConstant+((((elders.elderClass + elders.strength))*elders.strength)/10);
            elders.attackPoints         = (elders.agility * 65/100) + (elders.strength * 35/100);
            elders.mana                 = pvConstant+((((elders.elderClass + elders.intellegence))*elders.intellegence)/10);

            elders.primaryWeapon        = 1;
            elders.secondaryWeapon      = 1;
            elders.armor                = 1;
            elders.level                = 1;

            elders.head                 = uint256((uint256(_randomize(rand, "head", id)) % 15) + 1);            
            elders.race                 = uint256((uint256(_randomize(rand, "race", id) % 3)) + 1);

            uint256 uniqueId = ((rand % 2) + 1);       
            
           

        if(uniqueChance < (uniquesCount + 1) * 25 && uniques[elders.elderClass][uniqueId] == 0) {

            uniques[elders.elderClass][uniqueId] = id;
            elders.body     = uniqueId;
            uniquesCount++;

        }else{

            elders.body                 = uint256((uint256(_randomize(rand, "body", id)) % 2) + 13);        

        }

            eldersMeta[id] = EldersDataStructures.setElder( elders.strength, elders.agility, elders.intellegence,  
                                                            elders.attackPoints, elders.healthPoints, elders.mana, 
                                                            elders.primaryWeapon, elders.secondaryWeapon, elders.armor,
                                                            elders.level, elders.head, elders.body, elders.race, 
                                                            elders.elderClass);           

         _mint(_to, id);           

        }
     
     }

    function tokenURI(uint256 _id) external view returns(string memory) {

      return eldermetaDataHandler.getTokenURI(uint16(_id), eldersMeta[_id], isRevealed);

    }

    function getElder(uint256 _id) external view returns(EldersDataStructures.EldersMeta memory) {

      return EldersDataStructures.getElder(eldersMeta[_id]);

    }

    //////////FOR OFFCHAIN USE ONLY/////////////
    //uint256 strength,
                //uint256 agility,
                //uint256 intellegence,  
                //uint256 attackPoints,
                //uint256 healthPoints, 
                //uint256 mana,
                //uint256 primaryWeapon, 
                //uint256 secondaryWeapon,
                //uint256 armor,
                //uint256 level,
                //uint256 head,
                //uint256 body,
                //uint256 race,
                //uint256 elderClass
    function generateElderDna(uint256[14] calldata attributes)
    public returns (uint256) {

     return EldersDataStructures.setElder(attributes[0], attributes[1], attributes[2], 
                                          attributes[3], attributes[4], attributes[5], 
                                          attributes[6], attributes[7], attributes[8], 
                                          attributes[9], attributes[10], attributes[11], 
                                          attributes[12],attributes[13]);    
     
    }


    function decodeElderDna(uint256 character) external view returns(EldersDataStructures.EldersMeta memory) {
      return EldersDataStructures.getElder(character);
    } 


    
    function stake(uint256 _id) external {

         isPlayer();
         isElderOwner(_id);
         
         _transfer(msg.sender, address(this), _id);      
         elderOwner[_id] = msg.sender;
                    
    }


    
/*

█▀▄▀█ █▀█ █▀▄ █ █▀▀ █ █▀▀ █▀█ █▀
█░▀░█ █▄█ █▄▀ █ █▀░ █ ██▄ █▀▄ ▄█
*/

    function onlyOperator() internal view {    
       require(auth[msg.sender] == true, "not operator");

    }

    function onlyOwner() internal view {    
        require(admin == msg.sender, "not admin");
    }

    function isPlayer() internal {    
        uint256 size = 0;
        address acc = msg.sender;
        assembly { size := extcodesize(acc)}
        require((msg.sender == tx.origin && size == 0));
        ketchup = keccak256(abi.encodePacked(acc, block.coinbase));
    }

    function isElderOwner(uint256 id) internal view {    
        require(msg.sender == elderOwner[id] || msg.sender == ownerOf[id], "not your elder");
    }


    function _randomize(uint256 ran, string memory dom, uint256 ness) internal pure returns (uint256) {
    return uint256(keccak256(abi.encode(ran,dom,ness)));}

    function _rand() internal view returns (uint256) {
    return uint256(keccak256(abi.encodePacked(msg.sender, block.difficulty, block.timestamp, block.basefee, ketchup)));}




/*
▄▀█ █▀▄ █▀▄▀█ █ █▄░█   █▀▀ █░█ █▄░█ █▀▀ ▀█▀ █ █▀█ █▄░█ █▀
█▀█ █▄▀ █░▀░█ █ █░▀█   █▀░ █▄█ █░▀█ █▄▄ ░█░ █ █▄█ █░▀█ ▄█
*/

    function setAddresses(address _artifacts, address _inventory)  public {
       onlyOwner();
       
       artifacts            = IERC1155Lite(_artifacts);
       eldermetaDataHandler   = IEldersMetaDataHandler(_inventory);
       
    } 

    function flipMint () public {
        onlyOwner();
        isMintOpen = !isMintOpen;
    }

    function flipReveal () public {
        onlyOwner();
        isRevealed = !isRevealed;
    }   

    function setValidator(address _validator)  public {
       onlyOwner();
       validator = _validator;
    }
    
    function setAuth(address[] calldata adds_, bool status) public {
       onlyOwner();
       
        for (uint256 index = 0; index < adds_.length; index++) {
            auth[adds_[index]] = status;
        }
    }     


}