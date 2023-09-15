// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import  "./IERC20Permit.sol";
contract GasFreeTransfer{
     

    // permit function from DAI contract by virtue of the DAI smart contract address
    // function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) view external {


    // }

function sendToken (
    address _tokenAddress,
    address _sender, 
    address _receipient,
   uint fee, 
    uint _value, 
    uint _deadline,
    uint8 v, bytes32 r, bytes32 s
      ) public {
          IERC20Permit(_tokenAddress).permit(_sender, address(this), fee+_value, _deadline, v, r, s);
          IERC20Permit(_tokenAddress).transferFrom(_sender, _receipient, _value);
          IERC20Permit(_tokenAddress).transferFrom(_sender, msg.sender, fee);
    }


}

/*
this is the solution ... so the idea is that we need to send 

 100 DAI                                              1ETH
   A    pay 10                  ->                          B

   we want to do this without spending money on gas on the part of the sender ... 
             now if       B      has   ETH then B would be charged for txn fees 

             A     would sign a message and then when  A signs the message that tells the DAI contract to approve the txn 
             B     receives the message and then runs the permit function on the on the DAI contract and the pays for the transaction fees


***************WHAT IF YOU HAVE    B     having no money  then what do we do     we need another party    C   and    C   would like to charge you a fee  ..  C would also pay for the transaction fee********************

 100 DAI                                              0ETH                                1ETH
   A    pay 10                  ->                          B                               C

   we want to do this without spending money on gas on the part of the sender ... 
             now if       C      has   ETH then C would be charged for txn fees  and C would like to get a reward so would charge a fee

             A     would sign a message and then when  A signs the message that tells the DAI contract to approve the txn 
             C    receives the message and then runs the permit function on the on an IERC20PERMIT interface that is on the GasFreeContract 
             The smart contract by virtue of the DAI smart contract address can talk to the permit function and then the money 
             The money then goes to the GasFreeContract from             A          the          C takes her fee          B get the amount




*/





// PERMIT -  we call the permit function : so that the sender approves this contract to spend amount +   fee[txn fee for executing this fucnction]
// TRANSFERFROM (sender, receiver,  - so the amount in the first comment we tranfer that to the receiver
// then we transfer the fee to msg.sender