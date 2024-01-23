//SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

contract Util{

        function areEqual(address[] memory arr1, address[] memory arr2) public pure returns (bool) {
        if(arr1.length != arr2.length) {
            return false;
        }

        // Sort the arrays
        quickSort(arr1, int(0), int(arr1.length - 1));
        quickSort(arr2, int(0), int(arr2.length - 1));

        // Compare the sorted arrays
        for(uint i = 0; i < arr1.length; i++) {
            if(arr1[i] != arr2[i]) {
                return false;
            }
        }

        return true;
    }

    function quickSort(address[] memory arr, int left, int right) public pure {
        int i = left;
        int j = right;
        if(i==j) return;
        address pivot = arr[uint(left + (right - left) / 2)];
        while (i <= j) {
            while (arr[uint(i)] < pivot) i++;
            while (pivot < arr[uint(j)]) j--;
            if (i <= j) {
                (arr[uint(i)], arr[uint(j)]) = (arr[uint(j)], arr[uint(i)]);
                i++;
                j--;
            }
        }
        if (left < j)
            quickSort(arr, left, j);
        if (i < right)
            quickSort(arr, i, right);
    }

    function arraysAreEqualUsingHash(address[] memory arr1, address[] memory arr2) public pure returns (bool) {
        return keccak256(abi.encodePacked(arr1)) == keccak256(abi.encodePacked(arr2));
    }


    function contains(address addr, address[] memory array) public pure returns (bool) {
        for (uint i = 0; i < array.length; i++) {
            if (array[i] == addr) {
                return true;
            }
        }
        return false;
    }



    function createMappingKey(address _addr1, address _addr2) internal pure returns (bytes32){
        string memory addrStr1 = addressToString(_addr1);
        string memory addrStr2 = addressToString(_addr2);
        string memory result = concatenateStings(addrStr1, addrStr2);
        bytes32 hashResult = toHash(result);
        return hashResult;
    }

    function toHash(string memory _string) internal pure returns(bytes32) {
        return keccak256(abi.encodePacked(_string));
    }

    function concatenateStings(string memory a, string memory b) internal pure returns (string memory) {
        return string.concat(a,b);
    }

    function addressToString(address _addr) internal pure returns (string memory) {
        bytes32 value = bytes32(uint256(uint160(_addr)));
        bytes memory alphabet = "0123456789abcdef";
        bytes memory str = new bytes(42);
        str[0] = '0';
        str[1] = 'x';
         
        for (uint256 i = 0; i < 20; i++) {
            str[2 + i * 2] = alphabet[uint8(value[i + 12] >> 4)];
            str[3 + i * 2] = alphabet[uint8(value[i + 12] & 0x0f)];
        }
        return string(str);
    }
     
    // function toString(address _addr) internal pure returns (string memory) {
    //     bytes32 value = bytes32(uint256(uint160(_addr)));
    //     bytes memory alphabet = "0123456789abcdef";
    //     bytes memory str = new bytes(42);
    //     str[0] = '0';
    //     str[1] = 'x';
         
    //     for (uint256 i = 0; i < 20; i++) {
    //         str[2 + i * 2] = alphabet[uint8(value[i + 12] >> 4)];
    //         str[3 + i * 2] = alphabet[uint8(value[i + 12] & 0x0f)];
    //     }

    //     return string(str);
    // }




}