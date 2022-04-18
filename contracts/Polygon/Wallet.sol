// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.7;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "../Interfaces.sol";
import "hardhat/console.sol"; 

/*

███████╗██╗░░░░░██╗░░░██╗███████╗███╗░░██╗  ░██╗░░░░░░░██╗░█████╗░██╗░░░░░██╗░░░░░███████╗████████╗
██╔════╝██║░░░░░██║░░░██║██╔════╝████╗░██║  ░██║░░██╗░░██║██╔══██╗██║░░░░░██║░░░░░██╔════╝╚══██╔══╝
█████╗░░██║░░░░░╚██╗░██╔╝█████╗░░██╔██╗██║  ░╚██╗████╗██╔╝███████║██║░░░░░██║░░░░░█████╗░░░░░██║░░░
██╔══╝░░██║░░░░░░╚████╔╝░██╔══╝░░██║╚████║  ░░████╔═████║░██╔══██║██║░░░░░██║░░░░░██╔══╝░░░░░██║░░░
███████╗███████╗░░╚██╔╝░░███████╗██║░╚███║  ░░╚██╔╝░╚██╔╝░██║░░██║███████╗███████╗███████╗░░░██║░░░
╚══════╝╚══════╝░░░╚═╝░░░╚══════╝╚═╝░░╚══╝  ░░░╚═╝░░░╚═╝░░╚═╝░░╚═╝╚══════╝╚══════╝╚══════╝░░░╚═╝░░░

The Ethernal Elves Wallet
*/


contract ElvenWallet {

    using ECDSA for bytes32;

    IERC20Lite public ren;
    IERC20Lite public moon;
    IERC20Lite public slp;
    IElves public elves;
    ///////////////////////////////////////////////////////////////////////////////////////////

    bool public initialized;
    bool public isActive;
    address public admin;
    uint256 public slpSwapRate;    
    mapping(address => bool)   public auth;  
    uint256 moonForLPs;
    uint256 public moonForLPsLeft;
    
    
   
    ///Add more assets here

   function initialize() public {
    
       require(!initialized, "Already initialized");
       admin                = msg.sender;   
       initialized          = true;
       slpSwapRate          = 10;
    }

    function setAddresses(address _elves, address _ren, address _moon, address _slp)  public {
       onlyOwner();
       elves                = IElves(_elves);
       ren                  = IERC20Lite(_ren);
       moon                 = IERC20Lite(_moon);
       slp                  = IERC20Lite(_slp);
       isActive             = true;
    }

    function setSlpSwapRate(uint256 _slp)  public {
       onlyOwner();
       slpSwapRate                = _slp;
    }
    function setMoonForLP(uint256 _moonForLp)  public {
       onlyOwner();
       moonForLPs                = _moonForLp;
       moonForLPsLeft          = _moonForLp;     
    }

    function getSlpSwapRate() public view returns (uint256 swapRate) {            

            if (moonForLPsLeft <   500000 ether) return  ( 14 );
            if (moonForLPsLeft <   100000 ether) return  ( 18 );
            if (moonForLPsLeft <   150000 ether) return  ( 22 );
            if (moonForLPsLeft <   200000 ether) return  ( 26 );
            if (moonForLPsLeft <   400000 ether) return  ( 30 );
            if (moonForLPsLeft <   600000 ether) return  ( 34 );
            if (moonForLPsLeft <   900000 ether) return  ( 38 );
            if (moonForLPsLeft <= moonForLPs) return  ( 50 );

    }

    function setAuth(address[] calldata adds_, bool status) public {
        onlyOwner();
                
        for (uint256 index = 0; index < adds_.length; index++) {
               auth[adds_[index]] = status;
        }
    } 

    function flipActiveStatus() external {
        onlyOwner();
        isActive = !isActive;
    } 


    function deposit(address _owner, uint256 _tokenAmounts, uint256 tokenIndex) external {
        
            onlyOperator();
            checkWalletStatus();
            
            if(tokenIndex == 0){
                        elves.setAccountBalance(_owner, _tokenAmounts, false, 0);  
                        ren.burn(_owner, _tokenAmounts);

            }else if(tokenIndex == 1){
                        elves.setAccountBalance(_owner, _tokenAmounts, false, 1);      
                        moon.transferFrom(_owner, address(this), _tokenAmounts);
            }
            
    } 

        function withdraw(address _owner, uint256 _tokenAmounts, uint256 tokenIndex) external {
        
            onlyOperator();
            checkWalletStatus();
            
             if(tokenIndex == 0){
                        
                        elves.setAccountBalance(_owner, _tokenAmounts, true, 0);      
                        ren.mint(_owner, _tokenAmounts);
                      
             }else if(tokenIndex == 1){
                
                        elves.setAccountBalance(_owner, _tokenAmounts, true, 1);  
                        moon.transfer(_owner, _tokenAmounts);                           
                      
            }
            
    }

    function exchangeSLPForMoon(address _owner, uint256 _amount) external
    {   
        onlyOperator();
        checkWalletStatus();
        
        require(_amount > 0, "Amount is 0");
        require(_amount % 10**18 == 0, "Must be an integer amount of SLP");
        
        uint256 _swapRate = getSlpSwapRate();
        uint256 _moonAmount = _amount * _swapRate;
        
        require(moonForLPsLeft - _moonAmount > 0, "Not enough MOON");
        require(moonForLPsLeft > 0, "No MOON left");
         
        moonForLPsLeft = moonForLPsLeft - _moonAmount;        

        slp.transferFrom(_owner, address(this), _amount);           
        moon.transfer(_owner, _moonAmount);
        
    }


            ////////////////MODIFIERS//////////////////////////////////////////

            function checkBalance(uint256 balance, uint256 amount) internal view {    
            require(balance - amount >= 0, "notEnoughBalance");           
            }
            function checkWalletStatus() internal view {
            require(isActive, "walletInactive");       
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
            function onlyOwner() internal view {    
            require(admin == msg.sender);
            }

}



