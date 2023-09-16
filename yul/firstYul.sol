// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract FirstYul {
     uint public s;
    function sum (uint[] memory a) public pure returns(uint256 result){
        assembly {
            let n:=mload(a)
            for{let i:=0} lt(i,n) {i:=add(i,1)}{
                result:=add(result, mload(add(add(a, 0x20), mul(i,0x20))))
            }

        }
    }

    function lookup (uint256 i) public pure returns (uint256 result){
        assembly{
            switch i 
                case 0 {
                    result:=90
                }

                case 1 {
                    result:=91
                }

                case 2 {
                    result:=92
                }
            }
            
        
    }

    function compareAddress() public returns(bool isSame){

        

       
            s = (block.timestamp << 160) | uint256(uint160(msg.sender));
  address storedAddress =  address(uint160(s));
            assembly{
              
                 storedAddress:= shr(96, shl(96, storedAddress))

                isSame:= eq(caller(),storedAddress )
            }
         

       
    }

}

/*
in assembly you can get access to anything like storage and memory ; Solidity is a superset of Yul


mload : memory load 
mload(a)  : you are loading the first slot of the memory with the length of the array 


0x20  means 32 hexdecimal  every word in solidity is    32 bytes


*/