const { MerkleTree } = require('merkletreejs');
const keccak256 = require('keccak256');
const fs = require('fs');

const Whitelist = [
    '0xa1b1c1d1e1f1a1b1c1d1e1f1a1b1c1d1e1f1a1b1',
    '0xa2b2c2d2e2f2a2b2c2d2e2f2a2b2c2d2e2f2a2b2',
    '0xa3b3c3d3e3f3a3b3c3d3e3f3a3b3c3d3e3f3a3b3',
]

// Hash the addresses to create leaves (mapping of addr to hashes) for the Merkle tree
const leaves = Whitelist.map(addr => keccak256(addr.toLowerCase()));

// Create the Merkle tree using the leaves
// The `sortPairs` option ensures that the tree is built in a consistent order
const merkleTree = new MerkleTree(leaves, keccak256, {sortPairs: true});

// Get the Merkle root of the tree
const merkleRoot = merkleTree.getHexRoot();
console.log('Merkle Root:', merkleRoot);

const result = {
  merkleRoot: merkleRoot,
  whitelist: {}
};

// generate and print the Merkle proof for each address
for (const addr of Whitelist) {
    const leaf = keccak256(addr.toLowerCase());
    const proof = merkleTree.getHexProof(leaf);
    console.log(`Merkle Proof for ${addr}:`, proof);
    console.log(`Is ${addr} in the whitelist?`, merkleTree.verify(proof, leaf, merkleRoot));
    console.log(`Proof: ${JSON.stringify(proof)}`);
}

try {
  fs.writeFileSync('utils/merkleRoot.json', JSON.stringify(result, null, 2));
  console.log('merkle.json created at utils/merkle.json');
} catch (err) {
  console.error('Failed to write merkle.json:', err);
}







