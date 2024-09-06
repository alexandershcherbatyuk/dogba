// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

/**
 * @title DogBase
 * @dev Main contract for dog database
 */
contract DogBase is Ownable, ERC721 {
  
  string _tokenURI = "";
  uint lostFoundFee = 0.001 ether;
  uint marketFee = 0.001 ether;

  event NewDoge(uint indexed tokenId, string indexed name);
  event DogIsLost(uint indexed tokenId, string indexed name);
  event DogIsFound(uint indexed tokenId, string indexed name);
  event AddVaccine(uint indexed vacId, string indexed name, uint indexed tokenId);

  struct Dog {
      string name;
      string species;
      string breed;
      string sex;
      string country;
      string region;
      string city;
      string addr;
      string email;
      string tatoo;
      string color;
      string photo;
      uint32 birthday;
      uint32 postalCode;
      uint cellPhone;
      uint otherPhone;
  }

  struct LostDog {
      uint missingDate;
      string country;
      string region;
      string city;
      string addr;
  }

  struct FoundDog {
      uint foundDate;
      uint cellPhone;
      uint otherPhone;
      string email;
      address foundBy;
  }

  struct Vaccine {
    string name;
    string supplier;
    uint vatCenterId;
    uint code;
    uint date;
    uint dueDate;
  } 

  struct VatCenter {
    string name;
    string country;
    string region;
    string city;
    string addr;
    string email;
    uint phone;
  }

    VatCenter [] public vatCenters;

    mapping(uint => Dog) public dogs;
    mapping(uint => LostDog[])  public lostDogs;
    mapping(uint => FoundDog[])  public foundDogs;
    mapping(uint => Vaccine[]) public vaccines;
    mapping(uint => mapping(uint => address)) public vatCenterOfficials;

    constructor() Ownable(msg.sender) ERC721("DogBaseToken", "DBT") {}


    modifier dogOwner(uint _tokenId) {
      ownerOf(_tokenId);
      _;
    }
    /**
     * @dev Overwrides ERC721 contract _baseURI function in order to use private variable.
     */
    function _baseURI() internal view override returns (string memory) {
        return _tokenURI;
    }
    /*
    function loockUpDog2(uint _tokenId) external view return (Dog memory){
      return dogs[_tokenId];
    }
    */

    /**
     * @dev External view function returns data about a dog.
     */
    /*
    function loockUpDog(uint _tokenId) external view returns ( string name
                                                            string species,
                                                            string breed,
                                                            string sex,
                                                            string country,
                                                            string region,
                                                            string city,
                                                            string addr,
                                                            string email,
                                                            string tatoo,
                                                            string color,
                                                            uint32 birthday,
                                                            uint32 postalCode,
                                                            uint cellPhone,
                                                            uint otherPhone) {
      

      return( dogs[_tokenId].name
              dogs[_tokenId].species,
              dogs[_tokenId].breed,
              dogs[_tokenId].sex,
              dogs[_tokenId].country,
              dogs[_tokenId].region,
              dogs[_tokenId].city,
              dogs[_tokenId].addr,
              dogs[_tokenId].email,
              dogs[_tokenId].tatoo,
              dogs[_tokenId].color,
              dogs[_tokenId].birthday,
              dogs[_tokenId].postalCode,
              dogs[_tokenId].cellPhone,
              dogs[_tokenId].otherPhone);
    }
    */

    /**
     * @dev External view function returns data about lost and found dogs.
     */
    /*
    function loockUpLostFoundDog(uint _tokenId) external view returns (      
                                                                    uint missingDate,
                                                                    uint foundDate,
                                                                    uint cellPhone,
                                                                    uint otherPhone,
                                                                    string country,
                                                                    string region,
                                                                    string city,
                                                                    string email,
                                                                    address foundBy){
      return(
        lostFoundDogs[_tokenId].missingDate,
        lostFoundDogs[_tokenId].foundDate,
        lostFoundDogs[_tokenId].country,
        lostFoundDogs[_tokenId].region,
        lostFoundDogs[_tokenId].city,
        lostFoundDogs[_tokenId].cellPhone,
        lostFoundDogs[_tokenId].otherPhone,
        lostFoundDogs[_tokenId].email,
        lostFoundDogs[_tokenId].foundBy
      )
    }*/

    /**
     * @dev External view return vatCenters array.
     */
    /*
    function loockUpVatcenters() external view returns (VatCenter [] memory){
        return vatCenters;
    }*/

    /**
     * @dev Creates new entry for a dog.
     */
    function _newDog(uint _tokenId,
                    string memory _name,
                    string memory _species,
                    string memory _breed,
                    string memory _sex,
                    string memory _country,
                    string memory _region,
                    string memory _city,
                    string memory _addr,
                    string memory _email,
                    string memory _tatoo,
                    string memory _color,
                    uint32 _birthday,
                    uint32 _postalCode,
                    uint64 _cellPhone,
                    uint64 _otherPhone      
    ) internal {

        dogs[_tokenId].name = _name;
        dogs[_tokenId].species = _species;
        dogs[_tokenId].breed = _breed;
        dogs[_tokenId].sex = _sex;
        dogs[_tokenId].country = _country;
        dogs[_tokenId].region = _region;
        dogs[_tokenId].city = _city;
        dogs[_tokenId].addr = _addr;
        dogs[_tokenId].email = _email;
        dogs[_tokenId].tatoo = _tatoo;
        dogs[_tokenId].color = _color;
        dogs[_tokenId].birthday = _birthday;
        dogs[_tokenId].postalCode = _postalCode;
        dogs[_tokenId].cellPhone = _cellPhone;
        dogs[_tokenId].otherPhone = _otherPhone;
      emit NewDoge(_tokenId, _name);
    }
    /**
     * @dev Regesters a dog, microchip id is unique, would be used as tokenId
     */
    function regDoge(uint _chip, 
                    string memory _name,
                    string memory _species,
                    string memory _breed,
                    string memory _sex,
                    string memory _country,
                    string memory _region,
                    string memory _city,
                    string memory _addr,
                    string memory _email,
                    string memory _tatoo,
                    string memory _color,
                    uint32 _birthday,
                    uint32 _postalCode,
                    uint64 _cellPhone,
                    uint64 _otherPhone) public {
      require(bytes(_name).length > 0,"Dog name is required");
      require(bytes(dogs[_chip].name).length == 0,"This microchip has already been regestered");
      _newDog(_chip,  _name, _species, _breed, _sex, _country, _region, _city, _addr, _email, _tatoo, _color, _birthday, _postalCode, _cellPhone, _otherPhone);
      _safeMint(msg.sender,_chip);
    }

    /**
     * @dev Claim a dog is missing.
     */
    function claimDogIsLost(uint _tokenId, string memory _country,  uint _missingDate, string memory _region, string memory _city, string memory _addr) external dogOwner(_tokenId) {
        require(bytes(dogs[_tokenId].name).length > 0,"This dog has not yet been regestered.");

        lostDogs[_tokenId].push(LostDog(block.timestamp, _country, _region, _city, _addr));

        emit DogIsLost(_tokenId, dogs[_tokenId].name);
    }

     /**
     * @dev Claim a dog is found.
     */
    function claimDogIsFound(uint _tokenId, uint _foundDate, uint _cellPhone, uint _otherPhone, string memory _email) external {
        require(bytes(dogs[_tokenId].name).length > 0,"This dog has not yet been regestered.");

        foundDogs[_tokenId].push(FoundDog(block.timestamp,_cellPhone, _otherPhone, _email, msg.sender));

        emit DogIsFound(_tokenId, dogs[_tokenId].name);
    }

     /**
     * @dev Add dogs vaccination iformation.
     */
    function addVaccine(uint _tokenId, uint _vatCenterId, uint _date, uint _dueDate, uint _code, string memory _name, string memory _supplier) external dogOwner(_tokenId){
        vaccines[_tokenId].push(Vaccine(_name, _supplier, _vatCenterId, _date, _dueDate, _code));
        emit AddVaccine((vaccines[_tokenId].length - 1 ),_name,_tokenId);
    }

        /**
     * @dev Payable function to reward a person who would found a dog.
     */
    function payReward(uint _tokenId, address _foundBy) external payable dogOwner(_tokenId) {
        require(msg.value == lostFoundFee);
        address payable _dogFounder = payable(_foundBy);//address(uint160((lostFoundDogs[_tokenId].dogFoundBy))); 
        _dogFounder.transfer(msg.value);
    }

}