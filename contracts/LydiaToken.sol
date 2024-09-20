// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract LydiaStablecoin is ERC20, Ownable {
    uint256 public constant LYD_PRICE_IN_USD = 2 * 10**18; // Fixed price: 2 USD per Lydia (scaled by 18 decimals)

    constructor(address _owner) ERC20("LydiaToken", "LYD") Ownable(_owner) {
        _mint(_owner, 10_000_000_000 * 10**decimals()); // Mint 10 billion LYD tokens to deployer
    }

    // Function to get the fixed price of Lydia in USD
    function getPriceInUSD() public pure returns (uint256) {
        return LYD_PRICE_IN_USD; // 2 USD
    }

    // Mint function to create new Lydia tokens (owner-only)
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    // Burn function to remove Lydia tokens (owner-only)
    function burn(address from, uint256 amount) public onlyOwner {
        _burn(from, amount);
    }
}