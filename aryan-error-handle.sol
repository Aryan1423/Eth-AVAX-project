// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract aryan {
    function errorhandle(uint _value) public pure returns (bool) {

        require(_value > 5, "Greater than 5");

        uint newvalue = _value + 5;
        assert(newvalue > _value);

        if (_value == 11) {
            revert("It cannot be 10");}
        return true;
    }}