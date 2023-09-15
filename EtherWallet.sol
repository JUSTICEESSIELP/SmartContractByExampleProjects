// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract SimpleCustomWallet {

    event moneyDeposited(address indexed sender ,uint amount );
    event moneyWithdrawn(address indexed sender ,uint amount );

    address payable owner;
    uint private constant amountToSend = 3 ether;
    mapping(address => bool) hasAddressPaid;

    constructor(address payable _owner){
        owner = _owner;
    }

   modifier onlyOwner {
      require(msg.sender == owner);
      _;
   }
    receive() external payable {
          sendMoneyToContract();
    }


    function sendMoneyToContract () payable public {
        require(msg.sender != address(this), "Sender cannot be the smart contract");
        require(msg.value >= amountToSend, "Amount to send is 0.1 ether");
        hasAddressPaid[msg.sender] = true;
  

        emit moneyDeposited(msg.sender, msg.value);



    }

    function withdrawFromContract ()  payable onlyOwner public  {
        uint balanceOfContract = address(this).balance;
        (bool success,)= msg.sender.call{value: balanceOfContract}("");
        require(success, "Failed TXN");

        emit moneyWithdrawn(msg.sender, msg.value);


    }


}


// make the contract accept eth 
// only owner can withdraw 
