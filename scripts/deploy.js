const { ethers } = require("hardhat");

async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);

    const LydiaStablecoin = await ethers.getContractFactory("LydiaStablecoin");

    // Deploy the contract with the deployer's address (only one argument)
    const token = await LydiaStablecoin.deploy(deployer.address);

    // Wait for the contract to be deployed
    await token.waitForDeployment();

    // Output the contract address
    console.log("LydiaToken deployed to:", await token.getAddress());

    try {
        const totalSupply = await token.totalSupply();
        console.log("Initial Total Supply (raw):", totalSupply.toString());
    } catch (error) {
        console.error("Error fetching total supply:", error);
    }

    try {
        const priceInUSD = await token.getPriceInUSD();
        console.log("Price in USD (raw):", priceInUSD.toString());
    } catch (error) {
        console.error("Error fetching token price:", error);
    }
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
