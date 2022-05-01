pragma solidity ^0.8.7;

import 'erc721a-upgradeable/contracts/ERC721AUpgradeable.sol';
import "hardhat/console.sol";

/*

░█████╗░██████╗░████████╗░░██╗██╗███████╗░█████╗░░█████╗░████████╗░██████╗██╗░░
██╔══██╗██╔══██╗╚══██╔══╝░██╔╝██║██╔════╝██╔══██╗██╔══██╗╚══██╔══╝██╔════╝╚██╗░
███████║██████╔╝░░░██║░░░██╔╝░██║█████╗░░███████║██║░░╚═╝░░░██║░░░╚█████╗░░╚██╗
██╔══██║██╔══██╗░░░██║░░░╚██╗░██║██╔══╝░░██╔══██║██║░░██╗░░░██║░░░░╚═══██╗░██╔╝
██║░░██║██║░░██║░░░██║░░░░╚██╗██║██║░░░░░██║░░██║╚█████╔╝░░░██║░░░██████╔╝██╔╝░
╚═╝░░╚═╝╚═╝░░╚═╝░░░╚═╝░░░░░╚═╝╚═╝╚═╝░░░░░╚═╝░░╚═╝░╚════╝░░░░╚═╝░░░╚═════╝░╚═╝░░
*/

contract ElvesArtifacts is ERC721AUpgradeable {
string public constant header =
        '<svg id="art" width="100%" height="100%" version="1.1" viewBox="0 0 160 160" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">';
string public constant footer =
        "<style>#art{shape-rendering: crispedges; image-rendering: -webkit-crisp-edges; image-rendering: -moz-crisp-edges; image-rendering: crisp-edges; image-rendering: pixelated; -ms-interpolation-mode: nearest-neighbor;}</style></svg>";

address validator;
address admin;
mapping(bytes => uint256) public usedSignatures; 
mapping(uint8 => address) public art;
uint8 frames;
mapping(address => bool)    public auth;


function initialize() initializer public {
    __ERC721A_init('EthernalElves Artifacts', 'ELVA');
    admin = msg.sender;
    auth[msg.sender] = true;
}

function mint(uint256 quantity, uint256 timestamp, bytes memory tokenSignature) external {
    isPlayer();
    require(usedSignatures[tokenSignature] == 0, "Signature already used");   
    require(_isSignedByValidator(encodeTokenForSignature(quantity, msg.sender, timestamp),tokenSignature), "incorrect signature");
    usedSignatures[tokenSignature] = 1;    
    _safeMint(msg.sender, quantity);
  }

  function reserve(uint256 quantity) external {
    onlyOwner();
    _safeMint(msg.sender, quantity);
  }


  function burn(uint256[] calldata tokenIds) external {
    onlyOperator();
    
        for(uint i = 0; i < tokenIds.length; i++){
             _burn(tokenIds[i]);
        }
    
  }

  
  function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
        
        return getTokenURI(tokenId);
  }

       
//Cross chain validation

function encodeTokenForSignature(uint256 quantity, address owner, uint256 timestamp) public pure returns (bytes32) {
                return keccak256(
                        abi.encodePacked("\x19Ethereum Signed Message:\n32", 
                            keccak256(abi.encodePacked(quantity, owner, timestamp))
                                )
                            );
}  

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
//ADMIN

function onlyOwner() internal view {    
    require(admin == msg.sender);
}

function onlyOperator() internal view {    
    require(auth[msg.sender] == true, "not Authorized");    
}        

function isPlayer() internal {    
    uint256 size = 0;
    address acc = msg.sender;
    assembly { size := extcodesize(acc)}
    require((msg.sender == tx.origin && size == 0));
}

function setValidator(address _validator)  public {
    onlyOwner();       
    validator  = _validator;     
}

function setArt(uint8[] calldata ids, address source) external {
    require(msg.sender == admin, "Not authorized");

        for (uint256 index = 0; index < ids.length; index++) {
            art[ids[index]] = source;
            frames = frames + 1;           
        }
    }

//Onchain imaging

function getTokenURI(uint256 id_) public view returns (string memory) {
    
        string memory s = string(abi.encodePacked("art1()"));
        address source = art[1];

        (bool succ, bytes memory ret) = source.staticcall(abi.encodeWithSignature(s, ""));
        require(succ, "failed to get data");
      
        string memory artPiece = abi.decode(ret, (string));        
    
    
    
    

        string memory svg = Base64.encode(bytes(string(
                                                    abi.encodePacked(
                                                    header,
                                                    wrapTag(artPiece),                                                 
                                                    footer
                                                    ))));
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"ELVA #',
                                toString(id_),
                                '", "description":"EthernalElves Artifacts is a collection of artifacts required to awaken the Elders. These art pieces are 100% on-chain.", "image": "',
                                "data:image/svg+xml;base64,",
                                svg,
                                '",',
                                '"attributes": [{',
                                '"trait_type": "Generation",', 
                                '"value": "Elders"',
                                '}]',                                
                                "}"
                            )
                        )
                    )
                )
            );
    }

    function wrapTag(string memory uri) internal pure returns (string memory) {
        return
            string(
                abi.encodePacked(
                    '<image x="1" y="1" width="160" height="160" image-rendering="pixelated" preserveAspectRatio="xMidYMid" xlink:href="data:image/png;base64,',
                    uri,
                    '"/>'
                )
            );
    }

    ///
    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT licence
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

}


/// @title Base64
/// @author Brecht Devos - <brecht@loopring.org>
/// @notice Provides a function for encoding some bytes in base64
/// @notice NOT BUILT BY ETHERNAL ELVES TEAM.
library Base64 {
    string internal constant TABLE =
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

    function encode(bytes memory data) internal pure returns (string memory) {
        if (data.length == 0) return "";

        // load the table into memory
        string memory table = TABLE;

        // multiply by 4/3 rounded up
        uint256 encodedLen = 4 * ((data.length + 2) / 3);

        // add some extra buffer at the end required for the writing
        string memory result = new string(encodedLen + 32);

        assembly {
            // set the actual output length
            mstore(result, encodedLen)

            // prepare the lookup table
            let tablePtr := add(table, 1)

            // input ptr
            let dataPtr := data
            let endPtr := add(dataPtr, mload(data))

            // result ptr, jump over length
            let resultPtr := add(result, 32)

            // run over the input, 3 bytes at a time
            for {

            } lt(dataPtr, endPtr) {

            } {
                dataPtr := add(dataPtr, 3)

                // read 3 bytes
                let input := mload(dataPtr)

                // write 4 characters
                mstore(
                    resultPtr,
                    shl(248, mload(add(tablePtr, and(shr(18, input), 0x3F))))
                )
                resultPtr := add(resultPtr, 1)
                mstore(
                    resultPtr,
                    shl(248, mload(add(tablePtr, and(shr(12, input), 0x3F))))
                )
                resultPtr := add(resultPtr, 1)
                mstore(
                    resultPtr,
                    shl(248, mload(add(tablePtr, and(shr(6, input), 0x3F))))
                )
                resultPtr := add(resultPtr, 1)
                mstore(
                    resultPtr,
                    shl(248, mload(add(tablePtr, and(input, 0x3F))))
                )
                resultPtr := add(resultPtr, 1)
            }

            // padding with '='
            switch mod(mload(data), 3)
            case 1 {
                mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
            }
            case 2 {
                mstore(sub(resultPtr, 1), shl(248, 0x3d))
            }
        }

        return result;
    }
}
   