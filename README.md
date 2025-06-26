#### initiation
- created a merkle-access library to verify merkle proofs of members
- and a contract to approve a caller to claim access (by proving through the root hash) to a (yet) undefined function.
- why merkle proof instead of directly storing all members on chain? because storing on chain is expensive.
- the proof is a bytes32 array that holds the path from the leaf (msg.sender if true) to the rootHash
- the root hash is set by the owner/ contract deployer
- the owner has to get a new root everytime the whitelist changes through off chain interactions. 





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
