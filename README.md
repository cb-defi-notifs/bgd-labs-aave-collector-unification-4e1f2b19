# Collector Update <> Aave

This repository contains the latest version of the Aave Collector and the proposals to sync Collector implementations across different networks and markets.

At the moment there is quite a lot of divergence between the different collectors, even if they could have the same features and interfaces across all deployments of Aave (v2/v3). As a reference, we have chosen the version from this repository (https://github.com/bgd-labs/aave-ecosystem-reserve-v2), which is currently deployed on the Ethereum V2 market (https://etherscan.io/address/0x464c71f6c2f760dda6093dcb91c24c39e5d6e18c#readProxyContract), and made a few improvements to it.

All collectors use an "imperfect" pattern at the moment, based on a "controller of collector" to solve the problem of the proxy admin only being able to call admin functions on the proxy. We are aiming to generalize that controller of the ollector with a ProxyAdmin contract. This helps if in the future more functionality is added to the Collectors, as ProxyAdmin is not limited to the methods explicitly proxied; it is generic.

![collector-permissions-overview](./collector-admin.png)

## Deployment

As there is quite a lot of difference in the current layout of the Collectors/Markets for different networks there are a few different payloads.

1. `PayloadDeployment.sol` which contains multiple scripts which allow deploying a payload for a specific network.
2. `ProposalDeployment.sol` which contains a deploy script that will create the onchainProposals for all the networks controlled via governance (mainnet, polygon, optimism, arbitrum).
3. `AaveMigrationController.sol` payload is used for every network to deploy new implementation of the collector, proxy admin, and change funds admin of the collector.
4. `UpgradeV2ATokensPolygon` is additionally used for polygon to initialize the ATokens with the new collector and transfer all the assets from the current collector to the new one.
5. `UpgradeV2ATokensAvalanche` is additionally used for avalanche to initialize the ATokens with the new collector and transfer all the assets from the current collector to the new one by deploying the migration collector.

## Development

This project uses [Foundry](https://getfoundry.sh). See the [book](https://book.getfoundry.sh/getting-started/installation.html) for detailed instructions on how to install and use Foundry.
The template ships with sensible default so you can use default `foundry` commands without resorting to `MakeFile`.

### Setup

```sh
cp .env.example .env
forge install
```

### Test

```sh
forge test
```
