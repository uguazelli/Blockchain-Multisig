//SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

contract Util{

    function createMappingKey(address _addr1, address _addr2) internal pure returns (bytes32){
        string memory addrStr1 = convert(_addr1);
        string memory addrStr2 = convert(_addr2);
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

    function convert(address _address) internal pure returns (string memory) {
        string memory addrStr = toString(_address);
        return addrStr;
    }
     
    function toString(address _addr) internal pure returns (string memory) {
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



}