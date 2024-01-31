//SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;


contract Marriage {

    struct Details{
        address[] addresses;
        address[] confirmed;
        uint8 status;
        uint256 date;
        string agreement;
    }

    Details d;
    

    mapping(bytes32 => Details) private detailsById;
    mapping(address => bytes32[]) private idsByAddress;

   

    function getDetails(bytes32 _id) public view returns (Details memory){
        return detailsById[_id];
    }
    
    function getIds(address _address) public view returns (bytes32[] memory){
        return idsByAddress[_address];
    }


    function createContract(bytes32 _id, address[] memory _addresses, string memory _agreement ) public  {

        if(_id == 0x0000000000000000000000000000000000000000000000000000000000000000){
            _id = createIdentifier(_addresses);
            d = detailsById[_id];
            d.addresses = _addresses;
            d.confirmed = [msg.sender];
            d.status = 0;
            d.date = block.timestamp;
            d.agreement = _agreement;

        }else{
            d = detailsById[_id];

            if(areArraysEqual(d.addresses, d.confirmed)){
                d.status = 1;
            }

            if(!addressInArray(d.confirmed, msg.sender)) {
                d.confirmed.push(msg.sender);
            }   
               
        }
            if(!bytesInArray(idsByAddress[msg.sender], _id)){
                idsByAddress[msg.sender].push(_id);  
            }   

            detailsById[_id] = d;
            
        
        
        
    }

    function createIdentifier(address[] memory uniqueAddresses) private pure returns (bytes32) {
        return keccak256(abi.encodePacked(uniqueAddresses));
    }

    function bytesInArray(bytes32[] memory array, bytes32 value) private pure returns (bool) {
        for (uint i = 0; i < array.length; i++) {
            if (array[i] == value) {
                return true;
            }
        }
        return false;
    }

    function addressInArray(address[] memory array, address value) private pure returns (bool) {
        for (uint i = 0; i < array.length; i++) {
            if (array[i] == value) {
                return true;
            }
        }
        return false;
    }

    function areArraysEqual(address[] memory arr1, address[] memory arr2) private pure returns (bool) {
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

    function quickSort(address[] memory arr, int left, int right) private pure {
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


// TEST DATA

/*
 key 0x0000000000000000000000000000000000000000000000000000000000000000
 addr1 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
 aadr2 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
 status 1 (married)
 agreement MarriageTest

0x0000000000000000000000000000000000000000000000000000000000000000, [0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2], "MarriageTest"
 
 */
