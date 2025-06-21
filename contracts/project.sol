// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract DecentralizedBank {
    address public owner;
    mapping(address => uint256) public balances;
    mapping(address => uint256) public depositTimestamps;
    uint256 public interestRate = 5; // 5% annual interest

    constructor() {
        owner = msg.sender;
    }

    // Deposit Ether into the bank
    function deposit() external payable {
        require(msg.value > 0, "Deposit must be greater than 0");
        balances[msg.sender] += msg.value;
        depositTimestamps[msg.sender] = block.timestamp;
    }

    // Withdraw deposited Ether + simple interest
    function withdraw() external {
        uint256 userBalance = balances[msg.sender];
        require(userBalance > 0, "Insufficient balance");

        uint256 depositTime = block.timestamp - depositTimestamps[msg.sender];
        uint256 interest = (userBalance * interestRate * depositTime) / (100 * 365 days);

        uint256 amountToTransfer = userBalance + interest;
        balances[msg.sender] = 0;

        payable(msg.sender).transfer(amountToTransfer);
    }

    // View current balance
    function getBalance() external view returns (uint256) {
        return balances[msg.sender];
    }
}
