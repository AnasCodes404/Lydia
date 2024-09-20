// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract LydiaStablecoin is ERC20, Ownable {
    uint256 public constant LYD_PRICE_IN_USD = 2 * 10**18; // Fixed price: 2 USD per Lydia (scaled by 18 decimals)
    uint256 public transactionFeePercent = 1; // 1% transaction fee
    mapping(address => uint256) public loans; // Track loans by address
    uint256 public interestRate = 5; // 5% interest rate on loans (annual)

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

    // *** Transaction Fees ***
    // Override transfer function to include a transaction fee
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        uint256 fee = (amount * transactionFeePercent) / 100;
        uint256 amountAfterFee = amount - fee;

        _transfer(_msgSender(), recipient, amountAfterFee);
        _transfer(_msgSender(), address(this), fee); // Send fee to contract for revenue
        return true;
    }

    // Owner can set the transaction fee percentage
    function setTransactionFee(uint256 newFeePercent) external onlyOwner {
        transactionFeePercent = newFeePercent;
    }

    // *** Lending Services ***
    // Function to lend Lydia tokens to a borrower (owner-only)
    function lend(address borrower, uint256 amount) external onlyOwner {
        require(balanceOf(address(this)) >= amount, "Insufficient reserves");
        loans[borrower] += amount;
        _transfer(address(this), borrower, amount);
    }

    // Function for borrowers to repay the loan
    function repayLoan(uint256 amount) external {
        require(loans[msg.sender] > 0, "No loan found");
        uint256 interest = calculateInterest(loans[msg.sender]);
        require(amount >= loans[msg.sender] + interest, "Insufficient repayment");

        _transfer(msg.sender, address(this), amount);
        loans[msg.sender] = 0; // Clear loan
    }

    // Internal function to calculate loan interest
    function calculateInterest(uint256 loanAmount) internal view returns (uint256) {
        // Simple interest calculation (5% interest rate)
        uint256 interest = (loanAmount * interestRate) / 100;
        return interest;
    }
}
