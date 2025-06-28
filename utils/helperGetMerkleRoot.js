const fs = require('fs');

const data = JSON.parse(fs.readFileSync('utils/merkleRoot.json', 'utf-8'));
process.stdout.write(data.merkleRoot); // outputs only the root
// this will be used in the script to set the rootHash variable in the contract
// you can run this script using `forge script utils/generateMerkleRoot.js`