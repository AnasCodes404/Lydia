# Lydia Stablecoin

## Project Overview

The **LydiaStablecoin** project implements a stablecoin called **LydiaToken (LYD)**, which is pegged at a fixed value of **2 USD** per token. The contract allows the owner to mint and burn tokens and includes features such as lending services and transaction fees. The contract is deployed on the **Amoy Polygon testnet**.

## Features

- **Stable Price Mechanism**: The price of LydiaToken is determined dynamically by the prices of gold, silver, and platinum, fetched from reliable price oracles.
  
- **Minting and Burning**: The contract owner can mint new Lydia tokens or burn tokens from circulation.

- **Lending Services**: Lydia generates income by lending out tokens from its reserves, with a 5% annual interest rate.

- **Transaction Fees**: A 1% fee is applied on every transfer, which is sent to the contract as revenue.

- **Reentrancy Guard**: The contract includes protection against reentrancy attacks, ensuring that no external contract can repeatedly call certain functions.

- **Pausable Contract**: The owner can pause and unpause the contract in case of emergencies, halting all token transfers and lending activities.

- **Owner-Controlled Functions**: Only the contract owner can mint, burn tokens, and adjust critical parameters like the price feeds and transaction fees.

## Security Measures

- **Oracle Price Validation**: The contract validates the data fetched from the price oracles, ensuring that prices are always positive and valid before calculations.

- **Reentrancy Protection**: All critical functions (such as minting, burning, lending, and transferring tokens) are protected against reentrancy attacks using OpenZeppelin's `ReentrancyGuard`.

- **Pausable Contract**: The owner can pause all contract activities using the `Pausable` feature in case of security threats or other emergencies.

- **Transaction Fee Mechanism**: A 1% fee is applied on transfers to ensure continuous revenue generation for the project. This fee can be adjusted by the owner if needed.

- **Controlled Withdrawal of Fees**: The owner can securely withdraw accumulated transaction fees from the contract’s balance using a protected function.


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
