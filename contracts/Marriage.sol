//SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;


contract Marriage {

    struct ContractDetails {
        address[] addrs;
        address[] confirmedAddrs;
        uint8 status; // 0-Single; 1-Married; 2-Divorced; 3-Widowed; 4-Separated; 5-Civil union; 6-Domestic partnership
        uint8 confirmation; //0-Waiting confirmation; 1-Conrfirmed; 2-Canceled
        uint256 date;
        string agreement;
    }

    // Initialize the struct
    ContractDetails private contractDetails;


    function setContractDetails(bytes32 _contractNumber, address[] memory _addrs, uint8 _status, string memory _agreement) public{
        
        bool contractExists = _contractNumber != 0x0000000000000000000000000000000000000000000000000000000000000000;

        bytes32 contractNumber;

        if(!contractExists){
            contractNumber = createUniqueKey(_contractNumber);

            contractDetails.addrs = _addrs;
            contractDetails.confirmedAddrs = [msg.sender];
            contractDetails.status = _status;
            contractDetails.confirmation = 0;
            contractDetails.date = block.timestamp;
            contractDetails.agreement = _agreement;
            
        }else{
            contractNumber = _contractNumber;

            contractDetails = getDetailsByContractNumber(_contractNumber);
            
            if(!contains(msg.sender, contractDetails.confirmedAddrs)){
                contractDetails.confirmedAddrs.push(msg.sender);
            }
            if(areArraysEqual(contractDetails.addrs, contractDetails.confirmedAddrs)){
                contractDetails.confirmation = 1;
            }

        }

        setContractDetailsMapping(contractNumber, contractDetails);
        setAddrsContractsMapping(msg.sender, contractNumber);
        
    }

    //////////////////////////////////////////////////////////////////////////

    // Mapping ContractDetails to contractNumber
    mapping(bytes32 => ContractDetails) private contractDetailsMapping;

     // Getter functions
    function getDetailsByContractNumber(bytes32 _contractNumber) public view returns (ContractDetails memory) {
        return contractDetailsMapping[_contractNumber];
    }

    // Setter functions
    function setContractDetailsMapping(bytes32 key, ContractDetails memory value) private {
        contractDetailsMapping[key] = value;
    }

    //////////////////////////////////////////////////////////////////////////

    // Mapping an address to a list of contracts
    mapping(address => bytes32[]) private addrsContractsMapping;
   
    // Getter functions
     function getAddrsContractsMapping(address _address) public view returns (bytes32[] memory) {
        return addrsContractsMapping[_address];
    }

    // Setter functions
    function setAddrsContractsMapping(address _address, bytes32 _value) private {
        addrsContractsMapping[_address].push(_value);
    }


    //////////////////////////////////////////////////////////////////////////

    function createContractNumber() private view returns (bytes32) {
        return keccak256(abi.encodePacked(block.timestamp, msg.sender));
    }

    function createUniqueKey(bytes32 _contractNumber) private view returns(bytes32){
        bytes32 nullValue = 0x0000000000000000000000000000000000000000000000000000000000000000;
        return _contractNumber != nullValue ? _contractNumber: createContractNumber();
    }

    function contains(address addr, address[] memory array) private pure returns (bool) {
        for (uint i = 0; i < array.length; i++) {
            if (array[i] == addr) {
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

0x0000000000000000000000000000000000000000000000000000000000000000, [0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2], 1, "MarriageTest"
 
 */
