// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol"; // Import ReentrancyGuard
import "@openzeppelin/contracts/security/Pausable.sol"; // Import Pausable

contract LydiaStablecoin is ERC20, Ownable, ReentrancyGuard, Pausable {
    AggregatorV3Interface internal priceFeedGold;
    AggregatorV3Interface internal priceFeedSilver;
    AggregatorV3Interface internal priceFeedCopper;

    uint256 public transactionFeePercent = 1; // 1% transaction fee
    mapping(address => uint256) public loans; // Track loans by address
    uint256 public interestRate = 5; // 5% interest rate on loans (annual)

    constructor(
    address _owner,
    address _priceFeedGold,
    address _priceFeedSilver,
    address _priceFeedCopper
) ERC20("LydiaToken", "LYD") {  // No need to pass _owner to Ownable anymore
    priceFeedGold = AggregatorV3Interface(_priceFeedGold);
    priceFeedSilver = AggregatorV3Interface(_priceFeedSilver);
    priceFeedCopper = AggregatorV3Interface(_priceFeedCopper);

    _mint(_owner, 10_000_000_000 * 10**decimals()); // Mint 10 billion LYD tokens to deployer
}



    // Function to get the current price of Lydia in USD based on gold, silver, and copper prices
    function getPriceInUSD() public view returns (uint256) {
        (, int priceGold, , ,) = priceFeedGold.latestRoundData();
        (, int priceSilver, , ,) = priceFeedSilver.latestRoundData();
        (, int priceCopper, , ,) = priceFeedCopper.latestRoundData();

        require(priceGold > 0 && priceSilver > 0 && priceCopper > 0, "Invalid oracle prices");

        uint256 goldPrice = uint256(priceGold) * (10 ** (18 - priceFeedGold.decimals()));
        uint256 silverPrice = uint256(priceSilver) * (10 ** (18 - priceFeedSilver.decimals()));
        uint256 copperPrice = uint256(priceCopper) * (10 ** (18 - priceFeedCopper.decimals()));

        uint256 LYD_PRICE_IN_USD = (goldPrice * 80 / 100) + (silverPrice * 10 / 100) + (copperPrice * 10 / 100);
        return LYD_PRICE_IN_USD;
    }

    // Set new price feeds (only owner can call these)
    function setPriceFeedGold(address _priceFeedGold) external onlyOwner {
        priceFeedGold = AggregatorV3Interface(_priceFeedGold);
    }

    function setPriceFeedSilver(address _priceFeedSilver) external onlyOwner {
        priceFeedSilver = AggregatorV3Interface(_priceFeedSilver);
    }

    function setPriceFeedCopper(address _priceFeedCopper) external onlyOwner {
        priceFeedCopper = AggregatorV3Interface(_priceFeedCopper);
    }

    // Mint function (onlyOwner) with reentrancy and pause protection
    function mint(address to, uint256 amount) public onlyOwner nonReentrant whenNotPaused {
        _mint(to, amount);
    }

    // Burn function (onlyOwner) with reentrancy and pause protection
    function burn(address from, uint256 amount) public onlyOwner nonReentrant whenNotPaused {
        _burn(from, amount);
    }

    // Transfer function with transaction fees, reentrancy, and pause protection
    function transfer(address recipient, uint256 amount) public override nonReentrant whenNotPaused returns (bool) {
        uint256 fee = (amount * transactionFeePercent) / 100;
        uint256 amountAfterFee = amount - fee;

        _transfer(_msgSender(), recipient, amountAfterFee);
        _transfer(_msgSender(), address(this), fee); // Send fee to contract for revenue
        return true;
    }

    // Set new transaction fee (onlyOwner)
    function setTransactionFee(uint256 newFeePercent) external onlyOwner {
        transactionFeePercent = newFeePercent;
    }

    // Pausable functionality for emergency stopping
    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    // Lending services (onlyOwner)
    function lend(address borrower, uint256 amount) external onlyOwner nonReentrant whenNotPaused {
        require(balanceOf(address(this)) >= amount, "Insufficient reserves");
        loans[borrower] += amount;
        _transfer(address(this), borrower, amount);
    }

    // Borrower repays the loan with interest
    function repayLoan(uint256 amount) external nonReentrant whenNotPaused {
        require(loans[msg.sender] > 0, "No loan found");
        uint256 interest = calculateInterest(loans[msg.sender]);
        require(amount >= loans[msg.sender] + interest, "Insufficient repayment");

        _transfer(msg.sender, address(this), amount);
        loans[msg.sender] = 0; // Clear loan
    }

    // Internal interest calculation
    function calculateInterest(uint256 loanAmount) internal view returns (uint256) {
        return (loanAmount * interestRate) / 100;
    }
}
