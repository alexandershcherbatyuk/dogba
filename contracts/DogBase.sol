pragma solidity >=0.5.0 <0.8.21;

import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title DogBase
 * @dev Main contract for dog database
 */
contract DogBase is Ownable {
  
  event NewDoge(uint dogId, uint chip, uint32 birthday, string name, string species, string breed, string sex);

  struct Dog {
      uint chip;
      uint birthday;
      string name
      string species;
      string breed;
      string sex;
      address dogOnwer;
      address lstFoundBy;
  }

    Dog[] public dogs;

    /*struct Dog {
        string name;
        string species;
        string breed;
        string sex;
        string onwerFstName;
        string onwerLstName;
        string country;
        string region;
        string city;
        string email;
        string addr;
        string lang;
        string dogPhotoUrl;
        string tatoo;
        uint chipnumber;
        uint32 ownerBirthday;
        uint32 dogBirthday;
        uint32 created;
        uint32 updated;
        uint32 postalCode;
        uint64 cellPhone;
        uint64 otherPhone;
      }*/

    //mapping (uint => address) public dogChipOwner;

    mapping (uint => uint) public chipToDogId;

    function loockUpDog(uint _dogId) external view returns (    //uint chip,
                                                                uint32 birthday,
                                                                string memory name,
                                                                string memory species,
                                                                string memory breed,
                                                                string memory sex,
                                                                address dogOnwer,
                                                                address dogFoundBy
                                                              ) {
      //uint chip = dogChipOwner[_dogId]._chip;
      uint birthday = dogChipOwner[_dogId].birthday;
      string name = dogChipOwner[_dogId].name;
      string species = dogChipOwner[_dogId].species;
      string breed = dogChipOwner[_dogId].breed;
      string sex = dogChipOwner[_dogId].sex;
      address dogOnwer = dogChipOwner[_dogId].dogOnwer;

      return(chip, birthday, name, species, breed, sex, dogOnwer);
    }
    
    function newDog(uint _chip, uint _birthday, _string memory _name, _string memory _species, _string memory _breed, _string memory _sex, address _onwer) internal {
      uint id = dogs.push(Dog(uint32(_birthday), _name, _species, _breed, _sex, _owner, 0)) - 1;
      chipToDogId[_chip] = id;
      emit NewDoge(id, _chip, uint32(_birthday), _name, _species, _breed, _sex, _owner);
    }

}