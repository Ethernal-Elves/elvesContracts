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
    
   
    ///Add more assets here

   function initialize() public {
    
       require(!initialized, "Already initialized");
       admin                = msg.sender;   
       initialized          = true;
       slpSwapRate          = 1;
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
            
            if(tokenIndex == 0){
                        elves.setAccountBalance(_owner, _tokenAmounts, false, 0);  
                        ren.burn(_owner, _tokenAmounts);

            }else if(tokenIndex == 1){
                        //moon.burn(_owner, _tokenAmounts);
                        //moon.transfer(address(this), _tokenAmounts);
                        elves.setAccountBalance(_owner, _tokenAmounts, false, 1);      
                        moon.transferFrom(_owner, address(this), _tokenAmounts);
            }
            
    } 

        function withdraw(address _owner, uint256 _tokenAmounts, uint256 tokenIndex) external {
        
            onlyOperator();
            
             if(tokenIndex == 0){
                        
                        elves.setAccountBalance(_owner, _tokenAmounts, true, 0);      
                        ren.mint(_owner, _tokenAmounts);
                      
             }else if(tokenIndex == 1){
                
                        elves.setAccountBalance(_owner, _tokenAmounts, true, 1);  
                        //moon.transferFrom(address(this), _owner, _tokenAmounts); 
                        moon.transfer(_owner, _tokenAmounts);   
                        //moon.mint(_owner, _tokenAmounts);  
                      
            }
            
    }

    function exchangeSLPForMoon(uint256 _amount) external
    {   
        isPlayer();
        //require(daoAddress != address(0), "DAO address not set");
        require(_amount > 0, "Amount is 0");
        require(_amount % 10**18 == 0, "Must be an integer amount of SLP");
        require(moonForLPs != 0, "No Lp tokens left for this round");

         slp.transferFrom(msg.sender, address(this), _amount);
         uint256 _moonAmount = _amount * slpSwapRate;
         moon.transfer(msg.sender, _moonAmount);
         /// 10**18 *        
    }


            ////////////////MODIFIERS//////////////////////////////////////////

            function checkBalance(uint256 balance, uint256 amount) internal view {    
            require(balance - amount >= 0, "notEnoughBalance");           
            }
            function checkBridgeStatus() internal view {
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



