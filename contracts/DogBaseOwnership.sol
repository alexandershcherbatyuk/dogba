pragma solidity >=0.5.0 <0.8.21;

import "./DogBaseHelper.sol";

contract DogBaseOwnership is DogBaseHelper {
/*
    mapping (uint => address) dogsApprovals;

    function balanceOf(address _owner) external view returns (uint256) {
        uint counter = 0;
        for (uint i = 0; i < dogs.length; i++) {
        if (dogs[i].dogOnwer == _owner) {
            result[counter] = i;
            counter++;
        }
        return counter;
    }
        
     function ownerOf(uint256 _dogId) external view returns (address) {
        return dogs[_dogId].dogOwner;
    }

    function _transfer(address _from, address _to, uint256 _dogId) private {
        dogs[_dogId].dogOnwer = _to;
        emit Transfer(_from, _to, _dogId);
    }

    function transferFrom(address _from, address _to, uint256 _dogId) external payable {
      require (dogs[_dogId].dogOnwer  == msg.sender);
      _transfer(_from, _to, _dogId);
    }

    function approve(address _approved, uint256 _dogId) external payable ownerOf(_dogId) {
      dogsApprovals[_dogId] = _approved;
      emit Approval(msg.sender, _approved, _dogId);
    }
*/
}