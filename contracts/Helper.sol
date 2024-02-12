//SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

library Helper{

    // A function to check if the caller is an owner
    function isOwner(address[] memory participants) internal view returns (bool){
        bool owner = false;
        for (uint i = 0; i < participants.length; i++) {
            if (participants[i] == msg.sender) {
                owner = true;
                break;
            }
        }
        return owner;
    }

    function createIdentifier(address[] memory uniqueAddresses) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(uniqueAddresses));
    }

    function bytesInArray(bytes32[] memory array, bytes32 value) internal pure returns (bool) {
        for (uint i = 0; i < array.length; i++) {
            if (array[i] == value) {
                return true;
            }
        }
        return false;
    }

    function addressInArray(address[] memory array, address value) internal pure returns (bool) {
        for (uint i = 0; i < array.length; i++) {
            if (array[i] == value) {
                return true;
            }
        }
        return false;
    }

    function areArraysEqual(address[] memory arr1, address[] memory arr2) internal pure returns (bool) {
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

    function quickSort(address[] memory arr, int left, int right) internal pure {
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

}