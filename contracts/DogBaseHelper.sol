// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "hardhat/console.sol";

abstract contract DogBaseHelper is Ownable, ERC721  {

    string _tokenURI = "";
    uint lostFoundFee = 0.001 ether;
    uint marketFee = 0.001 ether;
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
        console.log(
              "setMarketFee: ", _fee
          );
        marketFee = _fee;
    }
   
    /**
     * @dev Onwer only external function to change baseURI.
     */
    function changeBaseURI(string memory _uri) external onlyOwner{
        _tokenURI = _uri;
    }

    /**
     * @dev Onwer only external function to change baseURI.
     */
    function getMarketFee() external view returns(uint){
        return marketFee;
    }


}