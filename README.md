# GoChain-f1

A Foundry-based smart contract project that implements a crowdfunding contract using Chainlink price feeds to convert ETH contributions into USD values.

## Overview

This repository includes a Solidity-based FundMe contract and the supporting deployment and test infrastructure built with Foundry. The project showcases:

- Foundry for compilation, scripting, and testing
- Chainlink ETH/USDT price feeds for real-time conversion
- forge-std for test assertions and utilities
- Foundry DevOps integration for tracking most recently deployed contracts

## Project Structure

- `src/` - Solidity smart contracts
  - `FundMe.sol` - main crowdfunding contract
  - `PriceConverter.sol` - Chainlink price feed integration
- `script/` - deployment and utility scripts
  - deployment scripts for deploying the FundMe contract and verifying using Foundry DevOps
- `test/` - Forge tests
  - unit and integration tests for funding, withdrawal, and price conversion behavior

## Key Features

- Accepts ETH contributions and records funders
- Uses Chainlink ETH/USDT price feeds to enforce contribution minimums in USD
- Allows owner withdrawal and handles multiple funders
- Includes robust Forge tests using `forge-std`
- Supports deployment automation and contract tracking with Foundry DevOps

## Setup

1. Install Foundry:

   ```bash
   curl -L https://foundry.paradigm.xyz | bash
   foundryup
   ```

2. Install project dependencies and build:

   ```bash
   forge install
   forge build
   ```

## Testing

Run the Forge test suite:

```bash
forge test
```

For forked network tests, provide an RPC URL:

```bash
forge test --fork-url <RPC_URL>
```
### Quickstart

Clone the repository and navigate into the project directory:

```bash
git clone https://github.com/Drosophila360/GoChain-f1.git
cd GoChain-f1
```

## Deployment

This project uses **Foundry Keystores (`cast wallet`)** instead of plain-text private keys in `.env` files to keep deployment credentials secure.

### Step 1: Set Up Credentials

#### 1. Obtain an RPC URL
1. Head over to [Alchemy](https://www.alchemy.com/) and create a free account.
2. Create an App for the **Ethereum Sepolia** network.
3. Copy your HTTPS RPC URL (e.g., `https://eth-sepolia.g.alchemy.com/v2/YOUR_API_KEY`).

#### 2. Get an Etherscan API Key
1. Register for a free account at [Etherscan](https://etherscan.io/).
2. Navigate to your Account Settings -> **API Keys** and generate a new key.

### Step 2: Configure Environment Variables

Create a `.env` file in the project root containing your RPC URL and Etherscan key (**do not put your private key here**):

```env
SEPOLIA_RPC_URL=https://eth-sepolia.g.alchemy.com/v2/YOUR_ALCHEMY_KEY
ETHERSCAN_API_KEY=YOUR_ETHERSCAN_API_KEY
```

### Step 3: Create an Encrypted Keystore

Import your private key into Foundry's encrypted wallet storage using `cast`:

```bash
cast wallet import devAccount --interactive
```

### Step 4: Configure Makefile in your root directory
```makefile
.PHONY: deploy-sepolia

deploy-sepolia:
	@forge script script/DeployFundMe.s.sol:DeployFundMe \
		--rpc-url $(SEPOLIA_RPC_URL) \
		--account AccountName \
		--sender Your_wallet_address \
		--broadcast \
		--verify \
		--etherscan-api-key $(ETHERSCAN_API_KEY) \
		-vvvv
```
### Step 5: Deploy your contract
```bash
make deploy-sepolia
```

## Notes

- Ensure the correct Chainlink ETH/USDT price feed address is configured for the target network.
- Review the `src/`, `script/`, and `test/` directories for contract behavior, deployment logic, and validation coverage.

## License

MIT

## Contact & Connect

[![Gmail](https://img.shields.io/badge/Gmail-D14836?style=for-the-badge&logo=gmail&logoColor=white)](mailto:drosophilamelanogaster380@gmail.com)
[![X (formerly Twitter)](https://img.shields.io/badge/X-000000?style=for-the-badge&logo=x&logoColor=white)](https://x.com/AlexMutham75513)