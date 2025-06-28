#### initiation
- created a merkle-access library to verify merkle proofs of members
- and a contract to approve a caller to claim access (by proving through the root hash) to a (yet) undefined function.
- why merkle proof instead of directly storing all members on chain? because storing on chain is expensive.
- the proof is a bytes32 array that holds the path from the leaf (msg.sender if true) to the rootHash
- the root hash is set by the owner/ contract deployer
- the owner has to get a new root everytime the whitelist changes through off chain interactions.

#### what more? 
- added another feature to the project, any approved member of the whitelist can swap USDC (ERC20) for eth through TokenRedemption.sol swap contract
- they get eth in return of their ERC20 token
- created a simple swap contract instead of routing to uniswap v2/v3 for exchange of tokens
- the users get eth and now this eth is what they will use for minting their own NFTs
- soon they will launch an auction of these NFTs 

#### 3rd commit
- a full merkle tree on chain storage would be expensive
- so i built an off chains cript for generating merkle root and getting the merkle root
- this merkle root will be called from merkle.json via ffi (foreign function interface) call during deployment
- (ffi allows forge script to call shell commands so you can run a JS, py, or bash scirpt from inside your forge sciprt/test and read its output directly into solidity)
- the json file acts like a bridge between off chain data/logic and on chain deployment/verification
- now when the approving contract (whitelist.sol) is deployed its constructor will set off the merkle root once and for all
- however
- what i intended initially was to make an editable whitelist (which still is off chain data) 
- since this happens off chain i wanted the contract to simultaneously take in the off chain generated root hash
- 
- creating a separate function (setNewRoot) in the contract for the owner to set root always the list changes is hectic for the owner/ deployer





## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
