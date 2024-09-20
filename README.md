# Lydia Stablecoin

## Project Overview

The **LydiaStablecoin** project implements a stablecoin called **LydiaToken (LYD)**, which is pegged at a fixed value of **2 USD** per token. The contract allows the owner to mint and burn tokens and includes features such as lending services and transaction fees. The contract is deployed on the **Amoy Polygon testnet**.

## Features

- **Fixed Price of 2 USD**: LydiaToken is always worth 2 USD.
- **Minting and Burning**: The contract owner can mint and burn Lydia tokens.
- **Lending Services**: Lydia generates income by lending tokens from its reserves and charging interest on loans.
- **Transaction Fees**: Transaction fees are applied to transfers and can be set by the contract owner, creating a revenue stream.
- **Owner-Controlled**: Only the contract owner has the authority to mint, burn, and manage lending services.

## Contract Details

- **Contract Name**: `LydiaStablecoin`
- **Token Name**: `LydiaToken (LYD)`
- **Contract Address**: `0x614312faDda106bB4a4b3ceb62CFfD6F750D096D` (Deployed on Amoy Polygon testnet)

## Usage

### Requirements

- Node.js v14 or higher
- Hardhat

### Installation

1. Clone the repository:
   git clone https://github.com/YOUR_USERNAME/Lydia.git
   cd Lydia

2. Install dependencies:
   npm install

### Deployment

Before deploying, ensure you have your private key and other network settings properly configured in your `.env` file.

3. Deploy the contract to the Amoy Polygon testnet:
   npx hardhat run scripts/deploy.js --network amoyPolygon

### Interacting with the Contract

4. Use the Hardhat console to interact with the deployed contract:
   npx hardhat console --network amoyPolygon

   Once inside the console, load the contract:
   const lydiaToken = await ethers.getContractAt("LydiaStablecoin", "0x614312faDda106bB4a4b3ceb62CFfD6F750D096D");

### Commands to Interact

5. Check the Fixed Price of Lydia:
   const price = await lydiaToken.getPriceInUSD();
   console.log(price.toString()); // Should return 2 * 10^18 (representing 2 USD)

6. Mint Lydia Tokens (only available for the owner):
   await lydiaToken.mint("0xYourAddressHere", ethers.parseUnits("1000", 18)); // Mint 1000 LYD tokens

7. Check Balance of an Address:
   const balance = await lydiaToken.balanceOf("0xYourAddressHere");
   console.log(balance.toString());

8. Burn Lydia Tokens (only available for the owner):
   await lydiaToken.burn("0xYourAddressHere", ethers.parseUnits("500", 18)); // Burn 500 LYD tokens

9. Lend Lydia Tokens (owner-only):
   await lydiaToken.lend("0xBorrowerAddressHere", ethers.parseUnits("1000", 18)); // Lend 1000 LYD tokens to the borrower

10. Repay a Loan:
   await lydiaToken.repayLoan(ethers.parseUnits("1050", 18)); // Repay 1050 LYD tokens (including interest)

### Transaction Fees

The contract includes a 1% transaction fee by default. You can check and update the transaction fee percentage:

11. Check Transaction Fee:
   const fee = await lydiaToken.transactionFeePercent();
   console.log(fee.toString());

12. Set Transaction Fee (owner-only):
   await lydiaToken.setTransactionFee(2); // Set a 2% transaction fee
