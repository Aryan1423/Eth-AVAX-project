# Eth-AVAX-project
This is a Solidity application where I implement the error-handling methods of Solidity. This program will provide the use case for all three error handling methods 
**require(), assert() and revert()** . The fundamental ideas of a Solidity, such as function and if condition, are used in this code.

# Description
This Solidity code builds a smart contract called aryan that shows how to handle errors by using the **assert(), revert(), and require()** statements into a single  function named **errorhandle()**. The function takes as input an unsigned integer **_value** and returns a boolean value. To make sure that _value is larger than 5, it utilises the **require()** statement. If the condition is not fulfilled, the transaction is reverted and the message "Greater than 5" is shown. It then uses the **assert()** statement to check that newvalue is less than 20, ensuring that the program's logic is accurate and reversing the transaction if the condition fails. After adding 5 to _value, the result is stored in a new variable called **newvalue**. Lastly, we use if block, if _value is 11, it expressly reverts the transaction using the **revert()** statement, stating "It cannot be 11". The function returns true in the event that every condition is met. This contract provides a clear example of how to utilise these statements to handle errors in Solidity.

# Getting Start
To start working with this programming language, you need first run the Remix online IDE, which is the solidity compiler, at https://remix.ethereum.org/ . Now, when the IDE launches, you have to create a file in which to write code. Click the new file option that shows up in the sidebar on the left to accomplish this. Choose a name for the file and save it with the .sol extension. Use aryan-error-handle.sol as an example.
```
// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract aryan {
    function errorhandle(uint _value) public pure returns (bool) {

        require(_value > 5, "Greater than 5");

        uint newvalue = _value + 5;
        assert(newvalue < 20 );

        if (_value == 11) {
            revert("It cannot be 11");}
        return true;
    }}
```

To start the code compilation process, select the "Solidity Compiler" tab from the left sidebar. Make sure the "Compiler" option is selected to "0.8.7" before clicking "Compile aryan-error-handle.sol". You can use the contract after the code has been compiled. One orange button representing the function will show up when the contract is deployed. Press the orange button and provide a value to test the errorhandle function. 

For example, the require() statement will fail and the error message "Greater than 5" will appear if you provide a number that is less than or equal to 5. An issue in logic within the contract will be shown by the assert() statement failing if you enter a number more than 5 provided that _value + 5 is not less than 20. Lastly, the revert() statement will execute and display the message "It cannot be 11" if you enter the value 11. You can see how the contract handles problems and makes sure that these statements follow right logic by testing various values.

# Explanation
The "aryan" contract was the first thing I made. I created the errorhandle function, which accepts a single unsigned integer input, _value, and outputs a boolean value. I used the require() statement within this function to make sure that _value is bigger than 5. The transaction is reversed with the error message "Greater than 5" if the condition is not satisfied. I then increased _value by 5 and saved the outcome in a brand-new variable called newvalue. In order to confirm that newvalue is smaller than 20, I used the assert() expression. Lastly, if _value is 11, I introduced a revert() statement that specifically reverses the transaction and prints the message "It cannot be 11". The function returns true if each of these criteria is met. This contract successfully illustrates how to handle errors in Solidity by using require(), assert(), and revert() to make sure the contract runs correctly and responds to incorrect inputs.

# License
This project is licensed under the MIT License - see the LICENSE.md file for details


