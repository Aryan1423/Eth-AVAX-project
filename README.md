# Eth-AVAX-project
This is a Solidity application where I implement the error-handling methods of Solidity. This program will provide the use case for all three error handling methods 
**require(), assert() and revert()** . The fundamental ideas of a Solidity, such as function and if condition, are used in this code.

# Description
This Solidity code creates the AryanBank smart contract, which shows how to handle errors in deposit and withdrawal methods by utilising the require(), assert(), and revert() statements. The agreement has two events, Deposit and Withdrawal, to record deposit and withdrawal operations, as well as a mapping to monitor balances for every address.

It is possible for users to add Ether to their accounts using the deposit() method. To make sure the deposit amount is more than 0, it employs the revert() statement. If this condition is not fulfilled, the transaction is reversed and the notice "Deposit amount must be greater than 0" is displayed. A Deposit event is then dispatched and the deposited amount is added to the sender's balance.

Users are able to withdraw a certain quantity of Ether from their account using the withdraw() method. In order to verify that the withdrawal amount is more than 0 and that the sender's balance is adequate to support the withdrawal, require() statements are used. The transaction is reversed with the relevant error messages if these requirements are not satisfied. In order to detect any potential logical mistakes, the assert() statement is used to verify that the withdrawal amount is less than 2000. The designated sum is taken out of the sender's balance, the ether is sent to them, and a Withdrawal event is generated if all requirements are satisfied.

Lastly, users may examine the balance of a specific account using the getBalance() method.

# Getting Start
To start working with this programming language, you need first run the Remix online IDE, which is the solidity compiler, at https://remix.ethereum.org/ . Now, when the IDE launches, you have to create a file in which to write code. Click the new file option that shows up in the sidebar on the left to accomplish this. Choose a name for the file and save it with the .sol extension. Use aryan-error-handle.sol as an example.
```
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
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint amount) external {
        require(amount > 0, "Withdraw amount must be greater than zero");
        require(balances[msg.sender] >= amount, "Insufficient balance");
        assert(amount < 2000);
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
        emit Withdrawal(msg.sender, amount);
    }

    function getBalance(address account) external view returns (uint) {
        return balances[account];
    }}

```

Choose the "Solidity Compiler" tab from the sidebar on the left to begin the code compilation process. Click "Compile aryan-bank.sol" only after making sure the "Compiler" option is set to "0.8.18". Once the code has been compiled, click the relevant button to deploy the contract.

You will see an orange buttons that represents the deposit and withdraw functionality after the contract is launched. Click the orange deposit button and input a value to test the deposit feature. For instance, the reverse() command will fail and the error message "Deposit amount must be greater than 0" would show if you attempt to deposit 0 Ether.

Similarly, click the orange withdraw button and input an amount to test the withdrawal feature. The "Insufficient balance" error notice will appear and the require() statement will fail if you attempt to withdraw more money than you have available. The assert() function will fail if you attempt to withdraw more than 2000, indicating a logical flaw in the contract.

You can observe how the contract handles mistakes and verifies that the reasoning is sound by experimenting with different values using these statements.

# Explanation
Making the "AryanBank" contract was my first step. I made two events, Deposit and Withdrawal, to record transactions and set a mapping to monitor address balances. To make sure the deposit amount is more than 0, I used the revert() statement in the deposit function. If the condition is not met, the transaction is reversed and the error message "Deposit amount must be greater than 0" appears. The Deposit event is then dispatched, and the deposited amount is added to the sender's balance.

I utilised require() statements in the withdraw method to make sure the sender's balance was sufficient and that the withdrawal amount was larger than 0. The transaction is reverted with the relevant error messages shown if these requirements are not satisfied. To make sure the withdrawal amount is less than 2000 and to identify any potential logical mistakes, I utilised the assert() statement. The designated sum is taken out of the sender's balance, the sender receives the Ether, and the Withdrawal event is emitted if all requirements are met. Users can examine the balance of a particular account by using the getBalance function. Using require(), assert(), and revert() to make sure the contract runs successfully and handles erroneous inputs appropriately, this contract effectively illustrates how to handle errors in Solidity.

# License
This project is licensed under the MIT License - see the LICENSE.md file for details


