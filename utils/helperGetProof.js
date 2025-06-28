// utils/getProof.js
const fs = require('fs');
const keccak256 = require('keccak256');

const address = process.argv[2].toLowerCase();
const data = JSON.parse(fs.readFileSync('utils/merkle.json'));
const proof = data.whitelist[address];

if (!proof) {
  throw new Error(`Proof not found for address ${address}`);
}

// Encode as ABI (so Solidity can decode)
const { defaultAbiCoder } = require('ethers');
const encoded = defaultAbiCoder.encode(["bytes32[]"], [proof]);
process.stdout.write(encoded);