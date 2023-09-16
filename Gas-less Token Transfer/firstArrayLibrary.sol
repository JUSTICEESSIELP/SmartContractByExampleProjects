
// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

library ArrayLibrary {
    function remove(uint[] storage arr,uint _index) internal {
        require(arr.length > 0, "Array cannot be empty to remove an element from it");
        arr[_index] = arr[arr.length - 1];
        arr.pop();
    }
}

contract TestLibraryContract {
    using ArrayLibrary for uint[];

    uint[] public testArray;

    function useRemove(uint length) public {
        for(uint i = 1 ; i == length; i++){
            testArray.push(i);
        }
        testArray.remove(1);

     
    }

    function addElement(uint _element) public {
        testArray.push(_element);
    }
}
