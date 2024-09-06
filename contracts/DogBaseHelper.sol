// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./DogBase.sol";

contract DogBaseHelper is DogBase{

    constructor() {
        
    }

    /**
     * @dev Onwer only external function to withdraw.
     */
    function withdraw() external onlyOwner {
        address payable _owner = payable(owner()); //address(uint160((owner()))); 
        _owner.transfer(address(this).balance);
    }
    /**
     * @dev Onwer only external function to change lostFoundFee.
     */
    function setLostFoundFee(uint _fee) external onlyOwner {
        lostFoundFee = _fee;
    }
    /**
     * @dev Onwer only external function to change marketFee.
     */
    function setMarketFee(uint _fee) external onlyOwner {
        marketFee = _fee;
    }
   
    /**
     * @dev Onwer only external function to change baseURI.
     */
    function changeBaseURI(string memory _uri) external onlyOwner{
        _tokenURI = _uri;
    }

}