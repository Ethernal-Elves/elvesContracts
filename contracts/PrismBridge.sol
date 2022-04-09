// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.7;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "./ERC721.sol"; 
import "./DataStructures.sol";
import "./Interfaces.sol";
//import "hardhat/console.sol"; 

/*
█▀█ █▀█ █ █▀ █▀▄▀█   █▄▄ █▀█ █ █▀▄ █▀▀ █▀▀
█▀▀ █▀▄ █ ▄█ █░▀░█   █▄█ █▀▄ █ █▄▀ █▄█ ██▄

The Ethernal Elves Gasles multichain bridge
*/


contract PrismBridge {

    using ECDSA for bytes32;

    bool public isBridgeOpen;    
    address public admin;
    
    mapping(address => bool)    public auth;  
    mapping(bytes => uint256)  public usedSignatures; 
    
    IERC20Lite public ren;
    IERC20Lite public moon;
    IElves public elves;



    event CheckIn(address indexed from, uint256 timestamp, uint256 indexed tokenId, uint256 indexed sentinel);      
    event CheckOut(address indexed to, uint256 timestamp, uint256 indexed tokenId);      
    event RenTransferOut(address indexed from, uint256 timestamp, uint256 indexed renAmount);  
    event RenTransferIn(address indexed from, uint256 timestamp, uint256 indexed renAmount); 

    event CheckInToPoly(address indexed from, uint256 timestamp, uint256[] tokenIds, uint256[] sentinels);      




   function initialize() public {
    
       require(!initialized, "Already initialized");
       admin                = msg.sender;   
       validator            = 0x80861814a8775de20F9506CF41932E95f80f7035;
    }

    function setAddresses(address _ren, address _moon, address _elves, address _validator)  public {
       onlyOwner();
       ren                  = IERC20Lite(_ren);
       moon                 = IERC20Lite(_moon);
       elves                = IElves(_elves);
       validator            = _validator;
    }  

//TRANSFERS TO ETH

    function checkInToEth(uint256[] calldata sentinelIds, uint256[] calldata elderIds, uint256 artifactsAmount, uint256 renAmount, uint256 moonAmount, address owner) public returns (bool) {
            
                onlyOperator();
                checkBridgeStatus();                  

                uint256 sentinelElves = ids.length;

                if (sentinelElves > 0) {

                    elves.exitElf(sentinelIds, owner);
                    emit CheckIn(owner, block.timestamp, ids[index], sentinels[ids[index]]);
                                                   
                }

                if (elderIds > 0) {/*wen elders? */}
               
                if (renAmount > 0) {
                    checkBalance(elves.bankBalances[owner], renAmount);                 
                    elves.setAccountBalance(owner, renAmount, true, 0);                           
                    //emit event        
                }

                if (moonAmount > 0) {
                    checkBalance(elves.moonBalances[owner], moonAmount);                 
                    elves.setAccountBalance(owner, moonAmount, true, 1);    
                    //emit event                                           
                }

                if (artifactsAmount > 0) {
                     checkBalance(elves.artifacts[owner], artifactsAmount);              
                     elves.setAccountBalance(owner, artifactsAmount, true, 2);          
                     //emit event
                }
            

        }

        function transferTokenToPolygon(uint256[] calldata tokenAmounts, uint256[] calldata tokenIndex, bytes[] memory tokenSignatures, uint256[] calldata timestamps, address[] calldata owners) public returns (bool) {
        
        onlyOperator();
        checkBridgeStatus();         
            

                for(uint i = 0; i < owners.length; i++){
                    require(usedSignatures[tokenSignatures[i]] == 0, "Signature already used");   
                    require(_isSignedByValidator(encodeTokenForSignature(tokenAmounts[i], owners[i], timestamps[i], tokenIndex[i]),tokenSignatures[i]), "incorrect signature");
                    usedSignatures[tokenSignatures[i]] = 1;
                    
                    if(tokenIndex[i] == 0){
                        elves.bankBalances[owners[i]] += tokenAmounts[i];     
                        emit RenTransferedIn(owners[i], tokenAmounts[i]);
                    }else if(tokenIndex[i] == 1){
                        elves.moonBalances[owners[i]] += tokenAmounts[i];     
                        emit MoonTransferedIn(owners[i], tokenAmounts[i]);
                    }
                     
                }            
            
        }



        


    function CheckOutToPolygon(uint256[] calldata ids, uint256[] calldata sentinel) external {
       onlyOperator();
       checkBridgeStatus();   
        
       elves.prismBridge(ids, sentinel);      
        
    }


            
//////////////EXPORT TO OTHER CHAINS/////////////////
// DataStructures.Elf memory elf = DataStructures.getElf(sentinels[id]);
function checkInToPolygon(uint256[] calldata ids, uint256 renAmount, uint256 moonAmount) public returns (bool) {
     
       isPlayer();
       checkBridgeStatus();           
         uint256 travelers = ids.length;
         address owner = msg.sender;
         if (travelers > 0) {
             elves.exitElf(ids, owner);
             //emit event
        }

        if (renAmount > 0) {  
            elves.bankBalances[owner] >= renAmount ? elves.setAccountBalance(owner, renAmount, true, 0) :  ren.burn(owner, renAmount);
            //emit event                        
        }
        if (moonAmount > 0) {  
            moon.burn(owner, renAmount);
            //emit event                        
        }
}

 function checkOut(uint256[] calldata ids, uint256[] calldata sentinel, bytes[] memory signatures, bytes[] memory authCodes) public returns (bool) {
   
    isPlayer();
    checkBridgeStatus(); 
    address owner = msg.sender;
     

     uint256 travelers = ids.length;
         if (travelers > 0) {

                for (uint256 index = 0; index < ids.length; index++) {  
                    
                    require(usedSignatures[signatures[index]] == 0, "Signature already used");   

                    require(_isSignedByValidator(encodeSentinelForSignature(ids[index], msg.sender, sentinel[index], authCodes[index]),signatures[index]), "incorrect signature");
                    usedSignatures[signatures[index]] = 1;

                    elf.prismBridge(ids, sentinel, owner);
                    //emit event
                }
         }

}

function transferTokenToEth(uint256[] calldata tokenAmounts, uint256[] calldata tokenIndex, bytes[] memory tokenSignatures, uint256[] calldata timestamps, address[] calldata owners) public returns (bool) {
        
        isPlayer();
        checkBridgeStatus();         
            

                for(uint i = 0; i < owners.length; i++){
                    require(usedSignatures[tokenSignatures[i]] == 0, "Signature already used");   
                    require(_isSignedByValidator(encodeTokenForSignature(tokenAmounts[i], owners[i], timestamps[i], tokenIndex[i]),tokenSignatures[i]), "incorrect signature");
                    usedSignatures[tokenSignatures[i]] = 1;
                    
                    if(tokenIndex[i] == 0){
                        ren.mint(msg.sender, renAmount);
                        emit RenTransferedIn(owners[i], tokenAmounts[i]);
                    }else if(tokenIndex[i] == 1){
                        moon.mint(msg.sender, renAmount);
                        emit MoonTransferedIn(owners[i], tokenAmounts[i]);
                    }
                     
                }            
            
}

//CheckOut Permissions 
function encodeSentinelForSignature(uint256 id, address owner, uint256 sentinel, bytes memory authCode) public pure returns (bytes32) {
     return keccak256(
            abi.encodePacked("\x19Ethereum Signed Message:\n32", 
                keccak256(
                        abi.encodePacked(id, owner, sentinel, authCode))
                        )
                    );
} 

function encodeTokenForSignature(uint256 tokenAmount, address owner, uint256 timestamp, uint256 tokenIndex) public pure returns (bytes32) {
            return keccak256(
                    abi.encodePacked("\x19Ethereum Signed Message:\n32", 
                        keccak256(
                                abi.encodePacked(tokenAmount, owner, timestamp, tokenIndex))
                                )
                            );
}  

//////////////////////////////////////////////////////////////////////////////////////////////////
  
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
            return signer == validator;
  
}

////////////////MODIFIERS//////////////////////////////////////////

function checkBalance(uint256 balance, uint256 amount) internal view {    
require(balance - amount >= 0, "notEnoughBalance");           
}
function checkBridgeStatus() internal view {
require(isBridgeOpen, "bridgenotOpen");       
}
function onlyOperator() internal view {    
require(msg.sender == admin || auth[msg.sender] == true);
}
function isPlayer() internal {    
uint256 size = 0;
address acc = msg.sender;
assembly { size := extcodesize(acc)}
require((msg.sender == tx.origin && size == 0));
}

/////////////////////////////////////////////////////////////////
function setAuth(address[] calldata adds_, bool status) public {
onlyOwner();
      
        for (uint256 index = 0; index < adds_.length; index++) {
            auth[adds_[index]] = status;
        }
    } 
}
function onlyOwner() internal view {    
        require(admin == msg.sender);
    }