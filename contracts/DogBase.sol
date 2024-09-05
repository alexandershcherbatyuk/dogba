pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

/**
 * @title DogBase
 * @dev Main contract for dog database
 */
contract DogBase is Ownable, ERC721 {
  
  string private _baseURI = "";

  event NewDoge(uint indexed tokenId, string indexed name);
  event DogIsLost(uint indexed tokenId, string indexed name);
  event DogIsFound(uint indexed tokenId, string indexed name);

  struct Dog {
      string name
      string species;
      string breed;
      string sex;
      string country;
      string region;
      string city;
      string addr;
      string lang;
      string email;
      string tatoo;
      string color;
      uint32 birthday;
      uint32 postalCode;
      uint cellPhone;
      uint otherPhone;
  }

  struct LostFoundDog {
      uint missingDate;
      uint foundDate;
      uint cellPhone;
      uint otherPhone;
      string email;
      string country;
      string region;
      string city;
      address foundBy;
  }

    mapping(uint => Dog) public dogs;
    mapping(uint => LostFoundDog)  public lostFoundDogs;

    constructor() ERC721("DogBaseToken", "DBT") {}

    /**
     * @dev Overwrides Ownable contract _baseURI function in order to use private variable.
     */
    function _baseURI() internal view virtual returns (string memory) {
        return _baseURI;
    }

    /**
     * @dev External view function returns data about a dog.
     */
    function loockUpDog(uint _tokenId) external view returns ( string name
                                                            string species,
                                                            string breed,
                                                            string sex,
                                                            string country,
                                                            string region,
                                                            string city,
                                                            string addr,
                                                            string lang,
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
              dogs[_tokenId].lang,
              dogs[_tokenId].email,
              dogs[_tokenId].tatoo,
              dogs[_tokenId].color,
              dogs[_tokenId].birthday,
              dogs[_tokenId].postalCode,
              dogs[_tokenId].cellPhone,
              dogs[_tokenId].otherPhone);
    }
    
    /**
     * @dev External view function returns data about lost and found dogs.
     */
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
    }
    
    /**
     * @dev Creates new entry for a dog.
     */
    function _newDog(uint _tokenId,
                    string _name,
                    string _species,
                    string _breed,
                    string _sex,
                    string _country,
                    string _region,
                    string _city,
                    string _addr,
                    string _lang,
                    string _email,
                    string _tatoo,
                    string _color,
                    uint _birthday,
                    uint32 _postalCode,
                    uint64 _cellPhone,
                    uint64 _otherPhone      
    ) internal {

        dogs[_tokenId].name = _name,
        dogs[_tokenId].species = _species,
        dogs[_tokenId].breed = _breed,
        dogs[_tokenId].sex = _sex,
        dogs[_tokenId].country = _country,
        dogs[_tokenId].region = _region;
        dogs[_tokenId].city = _city;
        dogs[_tokenId].addr = _addr;
        dogs[_tokenId].lang = _lang;
        dogs[_tokenId].email = _email;
        dogs[_tokenId].tatoo = _tatoo;
        dogs[_tokenId].color = _color;
        dogs[_tokenId].birthday = _birthday;
        dogs[_tokenId].postalCode = _postalCode'
        dogs[_tokenId].cellPhone = _cellPhone;
        dogs[_tokenId].otherPhone = _otherPhone;
      );
      emit NewDoge(_tokenId, _name);
    }
    /**
     * @dev Regesters a dog, microchip id is unique, would be used as tokenId
     */
    function regDoge(uint _chip, 
                    string _name,
                    string _species,
                    string _breed,
                    string _sex,
                    string _country,
                    string _region,
                    string _city,
                    string _addr,
                    string _lang,
                    string _email,
                    string _tatoo,
                    string _color,
                    uint _birthday,
                    uint32 _postalCode,
                    uint64 _cellPhone,
                    uint64 _otherPhone) public {

      reguire(dogs[_tokenId].name.length == 0,"This microchip has already been regestered");
      _newDog(_chip,  _name, _species, _breed, _sex, _country, _region, _city, _addr, _lang, _email, _tatoo, _color, _birthday, _postalCode, _cellPhone, _otherPhone);
      _safeMint(_owner,_chip);
    }

    /**
     * @dev Claim a dog is missing.
     */
    function claimDogIsLost(uint _tokenId, uint _missingDate, string memory _country,  uint _missingDate, string memory _region, string memory _city) public ownerOf(_tokenId) {
        reguire(dogs[_tokenId].name.length > 0,"This dog has not yet been regestered.");

        lostFoundDogs[_tokenId].missingDate = _missingDate;
        lostFoundDogs[_tokenId].country = _country;
        lostFoundDogs[_tokenId].region = _region;
        lostFoundDogs[_tokenId].city = _city;

        lostFoundDogs[_tokenId].foundDate = 0;
        lostFoundDogs[_tokenId].foundBy = 0;
        lostFoundDogs[_tokenId].cellPhone = 0,
        lostFoundDogs[_tokenId].otherPhone = 0;
        lostFoundDogs[_tokenId].email = '';

        emit DogIsLost(_tokenId, dogs[_tokenId].name);
    }

     /**
     * @dev Claim a dog is found.
     */
    function claimDogIsFound(uint _tokenId, uint _foundDate, uint _cellPhone, uint _otherPhone, string memory _email) public {
        reguire(dogs[_tokenId].name.length > 0);
        
        lostFoundDogs[_tokenId].foundDate = _foundDate;
        lostFoundDogs[_tokenId].foundBy = msg.sender;
        lostFoundDogs[_tokenId].cellPhone = _cellPhone,
        lostFoundDogs[_tokenId].otherPhone = _otherPhone;
        lostFoundDogs[_tokenId].email = _email;

        emit DogIsFound(_tokenId, dogs[_tokenId].name);
    }

}