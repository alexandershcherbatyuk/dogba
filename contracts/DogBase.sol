// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./DogBaseHelper.sol";

/**
 * @title DogBase
 * @dev Main contract for dog database
 */
contract DogBase is DogBaseHelper  {


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
      string tatoo;
      string color;
      string photo;
      string postalCode;
      uint birthday;
  }

  struct Contact {
      string email;
      string cellPhone;
      string otherPhone;
  }

  struct LostDog {
      uint missingDate;
      uint postalCode;
      string country;
      string region;
      string city;
      string addr;
  }

  struct FoundDog {
      uint foundDate;
      address foundBy;
  }

  struct Vaccine {
    string name;
    string supplier;
    string code;
    uint vetCenterId;
    uint date;
    uint dueDate;
  } 

  struct VetCenter {
    string name;
    string country;
    string region;
    string city;
    string addr;
    string email;
    string phone;
    string postalCode;
  }

  struct Order {
    uint price;
    uint tokenId;
    address dogOwner;
  }

    VetCenter [] public vetCenters;
    Order [] public market;

    mapping(uint => Dog) public dogs;
    mapping(uint => LostDog[])  public lostDogs;
    mapping(uint => FoundDog[])  public foundDogs;
    mapping(uint => Vaccine[]) public vaccines;
    mapping(uint => mapping(uint => address)) public vetCenterOfficials;
    mapping(address => Contact) public contacts;


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
   
    /**
     * @dev Creates new entry for a dog.
     */
    function _newDog(uint _tokenId, Dog memory _dog) internal {
        dogs[_tokenId] = _dog;
        emit NewDoge(_tokenId, _dog.name);
    }


    /**
     * @dev Regesters a dog, microchip id is unique, would be used as tokenId
     */
    function regDoge(uint _chip, Dog memory _dog, Contact memory _contact) external {
      //console.log("regDoge",_chip);
      require(bytes(_dog.name).length > 0,"Dog name is required");
      require(bytes(dogs[_chip].name).length == 0,"This microchip has already been regestered");
      _newDog(_chip, _dog);
      contacts[msg.sender] = _contact;
      _safeMint(msg.sender,_chip);
    }

    /**
     * @dev Claim a dog is missing.
     */
    function claimDogIsLost(uint _tokenId, LostDog memory _lostDog) external dogOwner(_tokenId) {

        //console.log("claimDogIsLost");
        require(bytes(dogs[_tokenId].name).length > 0,"This dog has not yet been regestered.");

        _lostDog.missingDate = block.timestamp;
        lostDogs[_tokenId].push(_lostDog);

        emit DogIsLost(_tokenId, dogs[_tokenId].name);
    }

     /**
     * @dev Claim a dog is found.
     */
    function claimDogIsFound(uint _tokenId, FoundDog memory _foundDog, Contact memory _contact) external {
        require(bytes(dogs[_tokenId].name).length > 0,"This dog has not yet been regestered.");

        _foundDog.foundDate = block.timestamp;
        contacts[_foundDog.foundBy] = _contact;
        foundDogs[_tokenId].push(_foundDog);

        emit DogIsFound(_tokenId, dogs[_tokenId].name);
    }

     /**
     * @dev Add dogs vaccination iformation.
     */
    function addVaccine(uint _tokenId, Vaccine memory _vaccine, uint _doctorId) external dogOwner(_tokenId){
        require(vetCenterOfficials[_vaccine.vetCenterId][_doctorId] == msg.sender);
        vaccines[_tokenId].push(_vaccine);
        emit AddVaccine((vaccines[_tokenId].length - 1 ),_vaccine.name,_tokenId);
    }

    /**
     * @dev Payable function to reward a person who would found a dog.
     */
    function payReward(uint _tokenId, address _foundBy) external payable dogOwner(_tokenId) {
        require(msg.value == lostFoundFee);
        address payable _dogFounder = payable(_foundBy);//address(uint160((lostFoundDogs[_tokenId].dogFoundBy))); 
        _dogFounder.transfer(msg.value);
    }

    function regVetCenter(VetCenter memory _vetCenter) external {
     //console.log("regVetCenter",_vetCenter.name);
      vetCenters.push(_vetCenter);
      //console.log("regVetCenter",vetCenters.length);

       vetCenterOfficials[vetCenters.length - 1][0] = msg.sender;
    }

    function addOrder(uint _price, uint _tokenId, address _dogOwner) external dogOwner(_tokenId) {
        market.push(Order(_price, _tokenId, _dogOwner));
    }

     function regVetCenterOfficial(uint _vetCenterId, uint _doctorId, address _doctor) external {
        require(vetCenterOfficials[_vetCenterId][0] == msg.sender);
        vetCenterOfficials[_vetCenterId][_doctorId] = _doctor;
    }

}