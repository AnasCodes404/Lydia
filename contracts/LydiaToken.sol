// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract LydiaStablecoin is ERC20, Ownable {
    AggregatorV3Interface internal priceFeedGold;
    AggregatorV3Interface internal priceFeedSilver;
    AggregatorV3Interface internal priceFeedCopper;

    uint256 public transactionFeePercent = 1; // 1% transaction fee
    mapping(address => uint256) public loans; // Track loans by address
    uint256 public interestRate = 5; // 5% interest rate on loans (annual)

    constructor(
        address _owner,
        address _priceFeedGold,  // Placeholder for gold price feed
        address _priceFeedSilver,  // Placeholder for silver price feed
        address _priceFeedCopper  // Placeholder for copper price feed
    ) ERC20("LydiaToken", "LYD") Ownable(_owner) {
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

        // Convert prices to 18 decimals and calculate LYD price based on the asset weights
        uint256 goldPrice = uint256(priceGold) * (10 ** (18 - priceFeedGold.decimals()));
        uint256 silverPrice = uint256(priceSilver) * (10 ** (18 - priceFeedSilver.decimals()));
        uint256 copperPrice = uint256(priceCopper) * (10 ** (18 - priceFeedCopper.decimals()));

        // Lydia token price is weighted: 80% gold, 10% silver, 10% copper
        uint256 LYD_PRICE_IN_USD = (goldPrice * 80 / 100) + (silverPrice * 10 / 100) + (copperPrice * 10 / 100);
        return LYD_PRICE_IN_USD;
    }

    // Function to set new price feeds (in case they change later)
    function setPriceFeedGold(address _priceFeedGold) external onlyOwner {
        priceFeedGold = AggregatorV3Interface(_priceFeedGold);
    }

    function setPriceFeedSilver(address _priceFeedSilver) external onlyOwner {
        priceFeedSilver = AggregatorV3Interface(_priceFeedSilver);
    }

    function setPriceFeedCopper(address _priceFeedCopper) external onlyOwner {
        priceFeedCopper = AggregatorV3Interface(_priceFeedCopper);
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
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        uint256 fee = (amount * transactionFeePercent) / 100;
        uint256 amountAfterFee = amount - fee;

        _transfer(_msgSender(), recipient, amountAfterFee);
        _transfer(_msgSender(), address(this), fee); // Send fee to contract for revenue
        return true;
    }

    function setTransactionFee(uint256 newFeePercent) external onlyOwner {
        transactionFeePercent = newFeePercent;
    }

    // *** Lending Services ***
    function lend(address borrower, uint256 amount) external onlyOwner {
        require(balanceOf(address(this)) >= amount, "Insufficient reserves");
        loans[borrower] += amount;
        _transfer(address(this), borrower, amount);
    }

    function repayLoan(uint256 amount) external {
        require(loans[msg.sender] > 0, "No loan found");
        uint256 interest = calculateInterest(loans[msg.sender]);
        require(amount >= loans[msg.sender] + interest, "Insufficient repayment");

        _transfer(msg.sender, address(this), amount);
        loans[msg.sender] = 0;
    }

    function calculateInterest(uint256 loanAmount) internal view returns (uint256) {
        uint256 interest = (loanAmount * interestRate) / 100;
        return interest;
    }
}
