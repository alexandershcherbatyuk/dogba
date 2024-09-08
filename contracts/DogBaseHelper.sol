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
     * @dev Withdraws the contract's balance to the owner's address.
     * Can only be called by the owner of the contract.
     */
    function withdraw() external onlyOwner {
        address payable _owner = payable(owner()); //address(uint160((owner()))); 
        _owner.transfer(address(this).balance);
    }

    /**
     * @dev Sets the fee for lost and found operations.
     * @param _fee The new fee amount to be set (in wei).
     * Can only be called by the owner of the contract.
     */
    function setLostFoundFee(uint _fee) external onlyOwner {
        lostFoundFee = _fee;
    }

    /**
     * @dev Sets the market fee.
     * @param _fee The new market fee amount to be set (in wei).
     * Can only be called by the owner of the contract.
     */
    function setMarketFee(uint _fee) external onlyOwner {
        console.log(
              "setMarketFee: ", _fee
          );
        marketFee = _fee;
    }

    /**
     * @dev Changes the base URI for the token metadata.
     * @param _uri The new base URI to be set.
     * Can only be called by the owner of the contract.
     */
    function changeBaseURI(string memory _uri) external onlyOwner {
        _tokenURI = _uri;
    }

    /**
     * @dev Retrieves the current market fee.
     * @return The current market fee (in wei).
     */
    function getMarketFee() external view returns(uint) {
        return marketFee;
    }

}
