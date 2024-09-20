require("@nomicfoundation/hardhat-ethers");
require("dotenv").config();

module.exports = {
  solidity: {
    compilers: [
      {
        version: "0.8.27", // For contracts like Lock.sol
      },
      {
        version: "0.8.20", // For OpenZeppelin contracts and others
      }
    ]
  },
  networks: {
    amoyPolygon: {
      url: "https://rpc-amoy.polygon.technology",
      chainId: 80002,  // Amoy Polygon Testnet Chain ID
      accounts: [`0x${process.env.PRIVATE_KEY}`],  // Your private key from .env
      gasPrice: 50000000000,  // Set the gas price (50 Gwei)
    },
  }
};

