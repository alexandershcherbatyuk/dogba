pragma solidity >=0.5.0 <0.8.21;

import "./DogBase.sol";

contract DogBaseHelper is DogBase {
  
    uint lostFoundFee = 0.002 ether;
    uint regFee = 0.001 ether;
    uint transferFee = 0.001 ether;

    modifier onlyDogOwner {uint _dogId) {
        //require(msg.sender  ===  dogs[chipToDog[_chip]].dogOnwer
        require(msg.sender  ===  dogs[_dogId].dogOnwer);
        return _;
    }

    function withdraw() external onlyOwner {
        //payable(owner());
        address payable _owner = address(uint160((owner()))); 
        _owner.transfer(address(this).balance);
    }

    function setLostFoundFee(uint _fee) external onlyOwner {
        lostFoundFee = _fee;
    }

    function setRegFee(uint _fee) external onlyOwner {
        regFee = _fee;
    }

    function setTransferFee(uint _fee) external onlyOwner {
        transferFee = _fee;
    }

    function payReward(uint _dogId) public payable onlyDogOwner(_dogId) {
        require(msg.value == lostFoundFee);
        address payable _dogFounder = address(uint160((dogs[_dogId].dogFoundBy))); 
        _dogFounder.transfer(msg.value);
    }

}