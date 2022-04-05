// scripts/upgrade-box.js
const { ethers, upgrades } = require("hardhat");

const payroll = [
{"wallet" : "0x3296d61c5e737f9847ba52267b1debb8dbff139f", "to": "R",      "amt": "3"},
{"wallet" : "0xccb6d1e4acec2373077cb4a6151b1506f873a1a5", "to": "S",	  "amt": "3"},
{"wallet" : "0x34db35639EAfe2712aE1F69dfa298b06a5c25053", "to": "S17a",   "amt": "0.2181"},
{"wallet" : "0xcf97bb94f405162f3F3AD433B709ebbd9B51e42d", "to": "P4L",    "amt": "0.0727"},
{"wallet" : "0x52A5431369A5E9b9b51D2c6b94F1e3Efd7d48062", "to": "etay",   "amt": "0.0727"},
{"wallet" : "0xB8956287dec237624F22F480340a11bb89315658", "to": "seven",  "amt": "0.03635"},
{"wallet" : "0x079bBFa2103e15a8E0B7fBB7FE2c5ffB317A2b39", "to": "dev",    "amt": "0.2181"}
]

const {MAINNET_PRIVATE_KEY} = process.env

async function payment(index) {

    let network = 'mainnet'
let provider = ethers.getDefaultProvider(network)

let privateKey = MAINNET_PRIVATE_KEY
// Create a wallet instance
let wallet = new ethers.Wallet(privateKey, provider)
// Receiver Address which receives Ether
let receiverAddress = payroll[index].wallet
// Ether amount to send
let amountInEther = payroll[index].amt
// Create a transaction object
let tx = {
    to: receiverAddress,
    // Convert currency unit from ether to wei
    value: ethers.utils.parseEther(amountInEther)
}
// Send a transaction
wallet.sendTransaction(tx)
.then((txObj) => {
    console.log('txHash', txObj.hash)
    // => 0x9c172314a693b94853b49dc057cf1cb8e529f29ce0272f451eea8f5741aa9b58
    // A transaction result can be checked in a etherscan with a transaction hash which can be obtained here.
})

}

async function main() {
   
//await payment(5)




}

main();