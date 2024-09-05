pragma solidity >=0.5.0 <0.8.21;

import "./DogBase.sol";

contract DogBaseHelper is DogBase {
  
    uint lostFoundFee = 0.001 ether;
    uint marketFee = 0.001 ether;

    /**
     * @dev Onwer only external function to withdraw.
     */
    function withdraw() external onlyOwner {
        address payable _owner = paybale(owner()); //address(uint160((owner()))); 
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
     * @dev Payable function to reward a person who would found a dog.
     */
    function payReward(uint _tokenId) public payable ownerOf(_tokenId) {
        require(msg.value == lostFoundFee);
        address payable _dogFounder = address(uint160((lostFoundDogs[_tokenId].dogFoundBy))); 
        _dogFounder.transfer(msg.value);
    }
    /**
     * @dev Onwer only external function to change baseURI.
     */
    function changeBaseURI(string memory _uri) external onlyOwner{
        _baseURI = _uri;
    }

}