// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract FactoryContractAddressPredictor{
// to get the address of a contract we use the owner of the contract address of the deployer of the contracts address;
// then we also use the number of transactions done by that deployer .. [nonce]
// then we RPL encode it and then we keccak256 hash it 

function getByteCode (address _ownersAddress, uint _numberOfTxn) public  returns(bytes memory){
    return 
}


}


contract TestContract{

    uint public number ;

    function setNewNumber(uint _number)public {
        number = _number;
    }
}