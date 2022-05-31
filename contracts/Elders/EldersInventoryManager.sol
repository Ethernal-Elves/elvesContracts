// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.7;
//import "hardhat/console.sol"; ///REMOVE BEFORE DEPLOYMENT
//v 1.0.3
import "hardhat/console.sol";
import "../ERC721.sol"; 
import "./DataStructures.sol";
import "../Interfaces.sol";

contract EldersInventoryManager {

    using EldersDataStructures for EldersDataStructures.EldersMeta;
    using EldersDataStructures for EldersDataStructures.EldersInventory;
   //mappings for item name, source address and struct
    string public constant header = '<svg id="elf" width="100%" height="100%" version="1.1" viewBox="0 0 160 160" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">';
    string public constant footer = "<style>#elf{shape-rendering: crispedges; image-rendering: -webkit-crisp-edges; image-rendering: -moz-crisp-edges; image-rendering: crisp-edges; image-rendering: pixelated; -ms-interpolation-mode: nearest-neighbor;}</style></svg>";

    mapping(uint256 => string) public itemName;
    mapping(uint256 => uint256) public itemMeta;
    
    struct EldersInventory {
           address source;
           string name;
    }

    string[6] public layers;
    string[9] public attributes;
    string[4] public displayTypes;
    bool isInitialized = false;
    address admin;

    
function initialize() public {
    admin = msg.sender;
    isInitialized = true;
    layers = ["Primary Weapon","Hair","Elder Class","Accessories","Abilities","Secondary Weapon"];
    attributes = ["Attack Points","Health Points","Mana","Race","Aether","Iron","Terra","Frost","Magma"];
    displayTypes = ["boost_number", "boost_percentage", "date", "number"];
}

 
function getTokenURI(uint16 id_, uint256 elder)
        external
        view
        returns (string memory)
    {
        
        string memory svg = Base64.encode(bytes(getSVG(elder)));
                
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"Elder #',
                                toString(id_),
                                '", "description":"EthernalElves Elders is a collection of 2222 Elders roaming the metaverse in search of the Mires. These Elves are 100% on-chain. Play EthernalElves to upgrade your abilities and grow your army. !onward", "image": "',
                                "data:image/svg+xml;base64,",
                                svg,
                                '",',
                                getAttributes(elder),                                                                   
                                "}"
                            )
                        )
                    )
                )
            );
    }

     function getSVG(uint256 elder) public view returns (string memory) {
      
      EldersDataStructures.EldersMeta memory item = EldersDataStructures.getElder(elder);
      
      string memory elder =  string(
                abi.encodePacked(
                    header,
                    get(uint8(item.primaryWeapon)),
                    get(uint8(item.primaryWeapon)),
                    get(uint8(item.primaryWeapon)),
                    get(uint8(item.primaryWeapon)),
                    get(uint8(item.primaryWeapon)),
                    get(uint8(item.primaryWeapon)),                                  
                    footer
                )
            );

        return elder;          
    }

     function getAttributes(uint256 elder) internal view returns (string memory) {
        
        EldersDataStructures.EldersMeta memory item = EldersDataStructures.getElder(elder);
        
        return
            string(
                abi.encodePacked(
                    '"attributes": [',
                    getLayerAttribute(0, uint8(item.primaryWeapon)),
                    ",",
                    getLayerAttribute(1, uint8(item.hair)),
                    ",",
                    getLayerAttribute(2, uint8(item.elderClass)),
                    ",",
                    getLayerAttribute(3, uint8(item.accessories)),
                    ",",
                    getLayerAttribute(4, uint8(item.abilities)),
                    ",",
                    getLayerAttribute(5, uint8(item.secondaryWeapon)),
                    ",",
                    getValueAttribute(0, uint8(item.attackPoints), 4),                   
                    "}]"
                )
            );
    }




    function setItemMeta(
        uint256 id,
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
        uint256 magma ) public {
        //onlyowner    
        itemMeta[id] = EldersDataStructures.setItem(source, attackPoints, healthPoints, manaPoints, layer, class, aether, iron, terra, frost, magma);

    }

    function setItemName(uint256 id, string memory name) public {
        //onlyowner
        itemName[id] = name;
    }


    function getItem(uint256 id) public returns(string memory name, uint256 item) {
        
        //this is for crafting abd c
        name = itemName[id];
        item = itemMeta[id];
       
       // EldersDataStructures.EldersInventory memory item = EldersDataStructures.getItem(itemMeta[id]);
    }


   function getLayerAttribute(uint8 layerId, uint8 id)
        internal
        view
        returns (string memory)
    {
        return
            string(
                abi.encodePacked(
                    '{"trait_type":"',
                    layers[layerId],
                    '","value":"',
                    itemName[id],
                    '"}'                    
                )
            );
    }

    function getValueAttribute(uint8 attributeId, uint8 value, uint8 displayType)
        internal
        view
        returns (string memory)
    {
        return
            string(
                abi.encodePacked(
                    '{"trait_type":"',
                    attributes[attributeId],
                    '","value":"',
                    toString(value),
                    '", "display_type":"',
                    displayTypes[displayType],
                    '"}'                    
                )
            );
    }



/*

█▀▄▀█ █▀█ █▀▄ █ █▀▀ █ █▀▀ █▀█ █▀
█░▀░█ █▄█ █▄▀ █ █▀░ █ ██▄ █▀▄ ▄█
*/

    function onlyOwner() internal view {    
        require(admin == msg.sender, "not admin");
    }

   
/*

█░█ █▀▀ █░░ █▀█ █▀▀ █▀█ █▀
█▀█ ██▄ █▄▄ █▀▀ ██▄ █▀▄ ▄█
*/


function call(address source, bytes memory sig) internal view returns (string memory svg)
{
    (bool succ, bytes memory ret) = source.staticcall(sig);
    require(succ, "failed to get data");
        
    svg = abi.decode(ret, (string));

}

function get(uint8 itemId) internal view returns (string memory data_)
{   
        EldersDataStructures.EldersInventory memory item = EldersDataStructures.getItem(itemId);
        address source = item.source;

        data_ = wrapTag(call(source, abi.encodeWithSignature(string(abi.encodePacked("elderArt", toString(itemId), "()")), "")));
         
        return data_;
}



function wrapTag(string memory ipfs) internal pure returns (string memory) {
        return
            string(
                abi.encodePacked(
                    '<image x="1" y="1" width="160" height="160" image-rendering="pixelated" preserveAspectRatio="xMidYMid" href="',
                    ipfs,
                    '"/>'
                )
            );
}


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
