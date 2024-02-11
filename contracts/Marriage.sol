//SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import "hardhat/console.sol";
import "./Helper.sol";

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


    function createContract(bytes32 _id, address[] memory _addresses, string memory _agreement ) public {

        if(_id == 0x0000000000000000000000000000000000000000000000000000000000000000){
            _id = Helper.createIdentifier(_addresses);
            d = detailsById[_id];
            d.addresses = _addresses;
            d.confirmed = [msg.sender];
            d.status = 0;
            d.date = block.timestamp;
            d.agreement = _agreement;

        }else{
            d = detailsById[_id];

            require(d.status == 0, "Status 1 cannot be modified.");

            if(!Helper.addressInArray(d.confirmed, msg.sender)) {
                d.confirmed.push(msg.sender);
            }   
            
            if(Helper.areArraysEqual(d.addresses, d.confirmed)){
                d.status = 1;
            }
               
        }
            if(!Helper.bytesInArray(idsByAddress[msg.sender], _id)){
                idsByAddress[msg.sender].push(_id);  
            }   

            detailsById[_id] = d;        
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
