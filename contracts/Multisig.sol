//SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import "hardhat/console.sol";
import "./Helper.sol";

contract Multisig {

    struct Details{
        address[] participants;
        address[] confirmed;
        uint8 contractStatus;
        uint256 date;
        string agreement;
    }

    Details details;

    mapping(bytes32 => Details) private detailsMapping;
    mapping(address => bytes32[]) private contractsMapping;


    function getDetails(bytes32 _id) public view returns (Details memory){
        return detailsMapping[_id];
    }
    

    function getIds(address _address) public view returns (bytes32[] memory){
        return contractsMapping[_address];
    }


    // Define an event that emits the id, the participants, and the agreement of a created agreement
    event AgreementCreated(bytes32 indexed id, address[] participants, string agreement);

    // Define an event that emits the id and the confirmations of a confirmed agreement
    event AgreementConfirmed(bytes32 indexed id, address[] confirmations);


    function createContract(address[] memory _participants, string memory _agreement ) public returns (bytes32) {
        
        require(Helper.isOwner(_participants), "Not owner");
     
        bytes32 id  = Helper.createIdentifier(_participants);

        bool idExists = Helper.bytesInArray(contractsMapping[msg.sender], id);

        if(!idExists){
            details.participants = _participants;
            details.confirmed = [msg.sender];
            details.contractStatus = 0;
            details.date = block.timestamp;
            details.agreement = _agreement;

            contractsMapping[msg.sender].push(id);  
            detailsMapping[id] = details;

            emit AgreementCreated(id, _participants, _agreement);

        }

        return id; 
    }


    function confirmContract(bytes32 _id) public {
      
        details = detailsMapping[_id];
        require(Helper.isOwner(details.participants), "Not owner");
        require(details.contractStatus == 0, "Status Confirmed cannot be modified.");

        // Push msg.sender to confirmed array
        if(!Helper.addressInArray(details.confirmed, msg.sender)) {
            details.confirmed.push(msg.sender);
        }

        // If msg.sender not in the mapping, push it
        if(!Helper.bytesInArray(contractsMapping[msg.sender], _id)){
            contractsMapping[msg.sender].push(_id);  
        }   
        
        // If confirmed matches participants, change staus
        if(Helper.areArraysEqual(details.participants, details.confirmed)){
            details.contractStatus = 1;
            emit AgreementConfirmed(_id, details.participants);
        }
            
        // Update details
        detailsMapping[_id] = details;       
    }

}


// TEST DATA

/*
 addr1 - 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
 aadr2 - 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2

 agreement - Multisig Test

 [0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2], "Multisig Test"


 Contract Address Metamask
 0x155a7a71349cc18bb17edf180044d89794faf39f
 
 */
