//SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import "hardhat/console.sol";
import "./Helper.sol";

contract Multisig {

    struct Details{
        address[] participants;
        address[] confirmed;
        uint8 status;
        uint256 date;
        string agreement;
    }

    Details d;

    mapping(bytes32 => Details) private detailsMapping;
    mapping(address => bytes32[]) private contractsMapping;


    function getDetails(bytes32 _id) public view returns (Details memory){
        return detailsMapping[_id];
    }
    
    function getIds(address _address) public view returns (bytes32[] memory){
        return contractsMapping[_address];
    }


    function createContract(address[] memory _participants, string memory _agreement ) public {

        bytes32 id  = Helper.createIdentifier(_participants);
        d = detailsMapping[id];
        d.participants = _participants;
        d.confirmed = [msg.sender];
        d.status = 0;
        d.date = block.timestamp;
        d.agreement = _agreement;

        contractsMapping[msg.sender].push(id);  
        detailsMapping[id] = d;   

    }

    function confirmContract(bytes32 _id) public {
      
            d = detailsMapping[_id];
            require(d.status == 0, "Status 1 cannot be modified.");

            // Push msg.sender to confirmed array
            if(!Helper.addressInArray(d.confirmed, msg.sender)) {
                d.confirmed.push(msg.sender);
            }

            // If msg.sender not in the mapping, push it
            if(!Helper.bytesInArray(contractsMapping[msg.sender], _id)){
                contractsMapping[msg.sender].push(_id);  
            }   
            
            // If confirmed matches participants, change staus
            if(Helper.areArraysEqual(d.participants, d.confirmed)){
                d.status = 1;
            }
               
            // Update details
            detailsMapping[_id] = d;        
    }

}


// TEST DATA

/*
 key - 0x0000000000000000000000000000000000000000000000000000000000000000
 addr1 - 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
 aadr2 - 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
 status - 0 - Pending / 1 Confirmed
 agreement - MarriageTest

0x0000000000000000000000000000000000000000000000000000000000000000, [0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2], "MarriageTest"
 
 */
