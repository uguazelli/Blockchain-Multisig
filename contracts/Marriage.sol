//SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import "./Util.sol";


contract Marriage is Util{
    
    struct marriageDetails{
        address addr1;
        address addr2;
        uint8 status; // 0-Single; 1-Married; 2-Divorced; 3-Widowed; 4-Separated; 5-Civil union; 6-Domestic partnership
        uint8 confirmation;//0-Waiting confirmation; 1-Conrfirmed;
        uint date;
        string  agreement;
        bytes32 agreementHash;
    }

    // mapping marriage number with details
    mapping(bytes32 => marriageDetails) private marriages;

    // an address can have multiple marriages, it is not up to us to decide if is right or not
    mapping(address => bytes32[]) private addressMarriages;


    function createContract(bytes32 _key, address _addr1, address _addr2, uint8 _status, string memory _agreement) public {
        
        // create a unique key if not provided
        bytes32 nullValue = 0x0000000000000000000000000000000000000000000000000000000000000000;
        bytes32 key = _key == nullValue ? createMappingKey(_addr1, _addr2) : _key;

        bool isContractRegistered = isContractSet(key, _addr1) || isContractSet(key, _addr1);

        if(!isContractRegistered){
            addressMarriages[_addr1].push(key);
            addressMarriages[_addr2].push(key);
        }

        // create a hash for the agreement string
        bytes32 agreementHash = toHash(_agreement);

        // start confirmation as 0-Waiting confirmation;
        uint8 confirmation = 0; 

        // if contract is registered, means one of the partners already created
        if(isContractRegistered){
            // if the hash for the agreement string matches
            // means that the partner agree with the terms, set it to 1
            if (agreementHash == marriages[key].agreementHash) {
            confirmation = 1;
            }
        }


        // create the marriage details
        marriages[key] = marriageDetails(
            _addr1,
            _addr2,
            _status,
            confirmation,            
            block.timestamp,
            _agreement,
            agreementHash
        );

      
    }

    function isContractSet(bytes32 key, address _addr) private view returns(bool){
        bool exists = false;
        for(uint8 i = 0; i < addressMarriages[_addr].length; i++){
            if(addressMarriages[_addr][i] == key){
                break;
            }
            exists = true;
        }

        return exists;
    }


}

// TEST DATA

/*
 key 0x0000000000000000000000000000000000000000000000000000000000000000
 addr1 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
 aadr2 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
 status 1 (married)
 agreement MarriageTest

 
 */

