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
      chainId: 80002,
      accounts: [`0x${process.env.PRIVATE_KEY}`]
    }
  }
};
