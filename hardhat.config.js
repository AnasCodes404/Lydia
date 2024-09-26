require("@nomicfoundation/hardhat-ethers");
require("dotenv").config();

module.exports = {
  solidity: {
    version: "0.8.20", // Specify the Solidity version
    settings: {
      optimizer: {
        enabled: true, // Enable the optimizer to reduce gas costs
        runs: 200, // Number of optimization runs
      },
    },
  },
  networks: {
    polygon: {
      url: "https://polygon.llamarpc.com",  // Polygon Mainnet RPC URL
      chainId: 137,  // Chain ID for the Polygon Mainnet
      accounts: [`0x${process.env.PRIVATE_KEY}`],  // Access private key from .env securely
      gasPrice: 50000000000,  // Set the gas price to 50 Gwei
    },
  },
  etherscan: {
    apiKey: process.env.POLYGONSCAN_API_KEY,  // Optional: Etherscan API key for contract verification (if needed)
  },
};
