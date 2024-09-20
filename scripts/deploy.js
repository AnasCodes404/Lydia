const { ethers } = require("hardhat");

async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);

    const LydiaStablecoin = await ethers.getContractFactory("LydiaStablecoin");

    // Deploy the contract with the deployer's address as the owner
    const token = await LydiaStablecoin.deploy(deployer.address);

    console.log("LydiaToken deployed to:", await token.getAddress());
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
