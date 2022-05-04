// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.7;
//import "hardhat/console.sol"; ///REMOVE BEFORE DEPLOYMENT
//v 1.0.3
import "hardhat/console.sol";
import "../ERC721.sol"; 
import "./DataStructures.sol";
import "../Interfaces.sol";

contract Elders is ERC721 {

    function name() external pure returns (string memory) { return "EthernalElves Elders"; }
    function symbol() external pure returns (string memory) { return "ELD"; }
       

    using EldersDataStructures for EldersDataStructures.EldersMeta;

    IERC1155Lite public artifacts;
    IElfMetaDataHandler public eldermetaDataHandler;

    bool public isGameActive;
    bool public isMintOpen;
    bool private initialized;
    address public validator;   
    uint256 public price;
    bytes32 ketchup;

    mapping(uint256 => uint256) public eldersMeta; //memory slot for Elder Metadata
    mapping(uint256 => uint256) public elderOwner; //memory slot for Owners, Timestamp and Actions
    mapping(address => bool) public auth; //memory slot for Authorized addresses

    function initialize() public {
    
       require(!initialized, "Already initialized");
       admin                = msg.sender;   
       maxSupply            = 2222; 
       initialized          = true;
       isGameActive         = true;
       isMintOpen           = true;
       price                = 7;  
       validator            = 0x80861814a8775de20F9506CF41932E95f80f7035;
       
    }



    function mint(uint256 quantity) external payable  returns (uint256 id) {
    
        isPlayer();
        require(isMintOpen, "Minting is closed");
        uint256 totalCost = price * quantity;

        require(artifacts.balanceOf(msg.sender, 1) >= totalCost, "Not Enough Artifacts");
        require(maxSupply - quantity >= 0, "No Elders Left");        
        
        artifacts.burn(msg.sender, 1, totalCost);

        return _mintElder(msg.sender, quantity);

    }


     function _mintElder(address _to, uint256 qty) private returns (uint16 id) {
        ////
        for(uint256 i = 0; i < qty; i++) {
            
         id = uint16(totalSupply + 1);   
         eldersMeta[id] = 1;
         _mint(_to, id);           

        }
     
     }

    function tokenURI(uint256 _id) external view returns(string memory) {
    return string("1"); //elfmetaDataHandler.getTokenURI(uint16(_id), sentinels[_id]);
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



/*
▄▀█ █▀▄ █▀▄▀█ █ █▄░█   █▀▀ █░█ █▄░█ █▀▀ ▀█▀ █ █▀█ █▄░█ █▀
█▀█ █▄▀ █░▀░█ █ █░▀█   █▀░ █▄█ █░▀█ █▄▄ ░█░ █ █▄█ █░▀█ ▄█
*/

    function setAddresses(address _artifacts, address _inventory)  public {
       onlyOwner();
       
       artifacts            = IERC1155Lite(_artifacts);
       eldermetaDataHandler   = IElfMetaDataHandler(_inventory);
       
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