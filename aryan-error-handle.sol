// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract AryanBank {

    mapping(address => uint) private balances;
    event Deposit(address indexed account, uint amount);
    event Withdrawal(address indexed account, uint amount);

    function deposit() external payable {
        if (msg.value==0) {
            revert("Deposit amount must be greater than 0");
        }
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);}

    function withdraw(uint amount) external {
        require(amount > 0, "Withdraw amount must be greater than zero");
        require(balances[msg.sender] >= amount, "Insufficient balance");
        assert(amount < 2000);
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
        emit Withdrawal(msg.sender, amount);}

    function getBalance(address account) external view returns (uint) {
        return balances[account];
    }}
