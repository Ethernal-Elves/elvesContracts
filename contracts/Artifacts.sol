pragma solidity ^0.8.7;

import 'erc721a-upgradeable/contracts/ERC721AUpgradeable.sol';

/*

░█████╗░██████╗░████████╗░░██╗██╗███████╗░█████╗░░█████╗░████████╗░██████╗██╗░░
██╔══██╗██╔══██╗╚══██╔══╝░██╔╝██║██╔════╝██╔══██╗██╔══██╗╚══██╔══╝██╔════╝╚██╗░
███████║██████╔╝░░░██║░░░██╔╝░██║█████╗░░███████║██║░░╚═╝░░░██║░░░╚█████╗░░╚██╗
██╔══██║██╔══██╗░░░██║░░░╚██╗░██║██╔══╝░░██╔══██║██║░░██╗░░░██║░░░░╚═══██╗░██╔╝
██║░░██║██║░░██║░░░██║░░░░╚██╗██║██║░░░░░██║░░██║╚█████╔╝░░░██║░░░██████╔╝██╔╝░
╚═╝░░╚═╝╚═╝░░╚═╝░░░╚═╝░░░░░╚═╝╚═╝╚═╝░░░░░╚═╝░░╚═╝░╚════╝░░░░╚═╝░░░╚═════╝░╚═╝░░
*/

contract ElvesArtifacts is ERC721AUpgradeable {
  
  address validator;
  address admin;
  mapping(bytes => uint256)  public usedSignatures; 


function initialize() initializer public {
    __ERC721A_init('EthernalElves Artifacts', 'ELVA');
}

function mint(uint256 quantity, uint256 timestamp, bytes memory tokenSignature) external payable {
    // _safeMint's second argument now takes in a quantity, not a tokenId.
    isPlayer();
    /*
    require(usedSignatures[tokenSignature] == 0, "Signature already used");   
    require(_isSignedByValidator(encodeTokenForSignature(quantity, msg.sender, timestamp),tokenSignature), "incorrect signature");
    usedSignatures[tokenSignature] = 1;
    */
    _safeMint(msg.sender, quantity);
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

//Onchain imaging

string public constant header =
        '<svg id="art" width="100%" height="100%" version="1.1" viewBox="0 0 160 160" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">';

string public constant footer =
        "<style>#art{shape-rendering: crispedges; image-rendering: -webkit-crisp-edges; image-rendering: -moz-crisp-edges; image-rendering: crisp-edges; image-rendering: pixelated; -ms-interpolation-mode: nearest-neighbor;}</style></svg>";

function getTokenURI(uint256 id_)
        public
        view
        returns (string memory)
    {

        string memory art1 = "iVBORw0KGgoAAAANSUhEUgAAAC0AAAAtCAYAAAA6GuKaAAAAAXNS";
        string memory art2 =  "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";
        string memory art = string(abi.encodePacked(art1,art2));

        string memory artFull =  string(
                abi.encodePacked(
                    header,
                    wrapTag(art),                                                 
                    footer
                )
            );
        string memory svg = Base64.encode(bytes (artFull));

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
                                //getAttributes(),
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
   