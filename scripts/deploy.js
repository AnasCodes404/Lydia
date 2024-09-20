const { ethers } = require("hardhat");

async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);

    const LydiaStablecoin = await ethers.getContractFactory("LydiaStablecoin");

    // Deploy the contract with the deployer's address as the owner
    const token = await LydiaStablecoin.deploy(deployer.address);

    // Wait for the contract to be deployed
    await token.waitForDeployment();

    // Output the contract address (in ethers v6, use getAddress() instead of target)
    console.log("LydiaToken deployed to:", await token.getAddress());

    try {
        // Fetch the total supply of the token
        const totalSupply = await token.totalSupply();
        console.log("Initial Total Supply (raw):", totalSupply.toString());

        // Convert BigInt to Number using BigInt division (Note: Be cautious if values are too large)
        const formattedTotalSupply = Number(totalSupply) / 10 ** 18;
        console.log("Initial Total Supply (formatted):", formattedTotalSupply);
    } catch (error) {
        console.error("Error fetching total supply:", error);
    }

    try {
        // Fetch the price in USD
        const priceInUSD = await token.getPriceInUSD();
        console.log("Price in USD (raw):", priceInUSD.toString());

        // Convert BigInt to Number for price as well
        const formattedPrice = Number(priceInUSD) / 10 ** 18;
        console.log("Token Price (USD):", formattedPrice);
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
