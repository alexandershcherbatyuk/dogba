// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./DogBaseHelper.sol";

/**
 * @title DogBase
 * @dev Main contract for managing a dog database, including registration, tracking, and rewards.
 */
contract DogBase is DogBaseHelper {

    /**
     * @dev Emitted when a new dog is registered.
     * @param tokenId The unique identifier of the dog.
     * @param name The name of the dog.
     * @param birthday The birthday of the dog.
     * @param breed The breed of the dog.
     * @param sex The sex of the dog.
     * @param owner The address of the dog owner.
     */
    event NewDoge(uint indexed tokenId, string indexed name, uint birthday, string breed, string sex, address owner);

    /**
     * @dev Emitted when a dog is reported lost.
     * @param tokenId The unique identifier of the lost dog.
     * @param addr The last known address of the lost dog.
     * @param date The date when the dog was reported lost.
     */
    event DogIsLost(uint indexed tokenId, string addr, uint date);

    /**
     * @dev Emitted when a dog is reported found.
     * @param tokenId The unique identifier of the found dog.
     * @param addr The address where the dog was found.
     * @param date The date when the dog was reported found.
     */
    event DogIsFound(uint indexed tokenId, string addr, uint date);

    /**
     * @dev Emitted when a new vaccine is added for a dog.
     * @param vacId The unique identifier of the vaccine.
     * @param name The name of the vaccine.
     * @param tokenId The unique identifier of the dog.
     * @param vetCentraId The unique identifier of the veterinary center.
     * @param date The date the vaccine was administered.
     */
    event AddVaccine(uint indexed vacId, string indexed name, uint indexed tokenId, uint vetCentraId, uint date);

    /**
     * @dev Emitted when a dog is listed on the marketplace.
     * @param tokenId The unique identifier of the dog.
     * @param price The price of the dog.
     * @param orderId The unique identifier of the order.
     */
    event MarketPlace(uint indexed tokenId, uint price, uint orderId);

    /**
     * @dev Emitted when a veterinary center is registered.
     * @param vetCentraId The unique identifier of the veterinary center.
     * @param name The name of the veterinary center.
     */
    event CenterVet(uint indexed vetCentraId, string indexed name);

    /**
     * @dev Emitted when a dog that was reported lost is confirmed found.
     * @param tokenId The unique identifier of the found dog.
     */
    event ConfirmDogFound(uint indexed tokenId);

    /**
     * @dev Emitted when a marketplace order is confirmed.
     * @param tokenId The unique identifier of the dog in the order.
     * @param orderId The unique identifier of the order.
     */
    event ConfitmMarketPlaceOrder(uint indexed tokenId, uint indexed orderId);

    // Struct definitions
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
        uint tokenId;
        uint missingDate;
        uint postalCode;
        string country;
        string region;
        string city;
        string addr;
    }

    struct FoundDog {
        uint tokenId;
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

    // State variables
    VetCenter[] public vetCenters;
    Order[] public market;
    LostDog [] public lostDogs;
    FoundDog [] public foundDogs;

    mapping(uint => Dog) public dogs;
    mapping(uint => Vaccine []) public vaccines;
    mapping(uint => mapping(uint => address)) public vetCenterOfficials;
    mapping(address => Contact) public contacts; 

    constructor() Ownable(msg.sender) ERC721("DogBaseToken", "DBT") {}

    /**
     * @dev Modifier to check if the caller is the owner of the dog.
     * @param _tokenId The unique identifier of the dog.
     */
    modifier dogOwner(uint _tokenId) {
        require(ownerOf(_tokenId) == msg.sender, "Not the owner of this token");
        _;
    }

    /**
     * @dev Overrides the ERC721 contract's _baseURI function to use the private _tokenURI variable.
     * @return The base URI for the token metadata.
     */
    function _baseURI() internal view override returns (string memory) {
        return _tokenURI;
    }

    /**
     * @dev Creates a new entry for a dog.
     * @param _tokenId The unique identifier for the dog (e.g., microchip ID).
     * @param _dog The details of the dog being registered.
     */
    function _newDog(uint _tokenId, Dog memory _dog) internal {
        dogs[_tokenId] = _dog;
        emit NewDoge(_tokenId, dogs[_tokenId].name, dogs[_tokenId].birthday, dogs[_tokenId].breed, dogs[_tokenId].sex, msg.sender);
    }

    /**
     * @notice Registers a new dog with a microchip ID and stores its details.
     * @param _chip The microchip ID (used as tokenId) of the dog.
     * @param _dog The details of the dog.
     * @param _contact Contact information for the dog's owner.
     */
    function regDoge(uint _chip, Dog memory _dog, Contact memory _contact) external {
        require(bytes(_dog.name).length > 0, "Dog name is required");
        require(bytes(dogs[_chip].name).length == 0, "This microchip has already been registered");
        _newDog(_chip, _dog);
        contacts[msg.sender] = _contact;
        _safeMint(msg.sender, _chip);
    }

    /**
     * @notice Claims that a dog is missing and updates the record with lost details.
     * @param _tokenId The token ID of the missing dog.
     * @param _lostDog The details of the lost dog.
     */
    function claimDogIsLost(uint _tokenId, LostDog memory _lostDog) external dogOwner(_tokenId) { 
        require(bytes(dogs[_tokenId].name).length > 0, "This dog has not yet been registered");
        _lostDog.missingDate = block.timestamp;
        lostDogs.push(_lostDog);
        emit DogIsLost(_tokenId, dogs[_tokenId].addr, _lostDog.missingDate);
    }

    /**
     * @notice Claims that a dog has been found and updates the record with found details.
     * @param _tokenId The token ID of the found dog.
     * @param _foundDog The details of the found dog.
     * @param _contact Contact information for the person who found the dog.
     */
    function claimDogIsFound(uint _tokenId, FoundDog memory _foundDog, Contact memory _contact) external {
        require(bytes(dogs[_tokenId].name).length > 0, "This dog has not yet been registered");
        _foundDog.foundDate = block.timestamp;
        contacts[_foundDog.foundBy] = _contact;
        foundDogs.push(_foundDog);
        emit DogIsFound(_tokenId, dogs[_tokenId].addr, _foundDog.foundDate);
    }

    /**
     * @notice Adds vaccination information for a dog.
     * @param _tokenId The token ID of the dog.
     * @param _vaccine The vaccination details.
     * @param _doctorId The ID of the veterinarian who administered the vaccine.
     */
    function addVaccine(uint _tokenId, Vaccine memory _vaccine, uint _doctorId) external dogOwner(_tokenId) {
        require(vetCenterOfficials[_vaccine.vetCenterId][_doctorId] == msg.sender, "Unauthorized vet");
        vaccines[_tokenId].push(_vaccine);
        emit AddVaccine(vaccines[_tokenId].length - 1, _vaccine.name, _tokenId, _vaccine.vetCenterId, _vaccine.date);
    }

    /**
     * @notice Rewards the person who found a missing dog.
     * @param _tokenId The token ID of the found dog.
     * @param _foundBy The address of the person who found the dog.
     */
    function payReward(uint _tokenId, address _foundBy) external payable dogOwner(_tokenId) {
        require(msg.value == lostFoundFee, "Incorrect reward amount");
        address payable _dogFounder = payable(_foundBy);
        _dogFounder.transfer(msg.value);
        emit ConfirmDogFound(_tokenId);
    }

    /**
     * @notice Registers a new veterinary center.
     * @param _vetCenter The details of the veterinary center to be registered.
     */
    function regVetCenter(VetCenter memory _vetCenter) external {
        vetCenters.push(_vetCenter);
        uint vetCentersId = vetCenters.length - 1;
        vetCenterOfficials[vetCentersId][0] = msg.sender;
        emit CenterVet(vetCentersId, vetCenters[vetCentersId].name);
    }

    /**
     * @notice Adds a new order to the market.
     * @param _price The price of the order.
     * @param _tokenId The token ID of the dog being sold.
     */
    function addOrder(uint _price, uint _tokenId) external dogOwner(_tokenId) {
        market.push(Order(_price, _tokenId, msg.sender));
        uint orderId = market.length - 1;
        emit MarketPlace(_tokenId, _price, orderId);
    }

    /**
     * @notice Sells a dog listed on the marketplace.
     * @param _tokenId The token ID of the dog being sold.
     * @param _to The address of the buyer.
     * @param _orderId The ID of the marketplace order.
     */
    function sellOrder(uint _tokenId, address _to, uint _orderId) external payable {
        require(ownerOf(_tokenId) != msg.sender, "Seller cannot buy own dog");
        require(msg.value == (marketFee + market[_orderId].price), "Incorrect payment amount");
        safeTransferFrom(ownerOf(_tokenId), _to, _tokenId);
        emit ConfitmMarketPlaceOrder(_tokenId, _orderId);
    }

    /**
     * @notice Registers a new official at a veterinary center.
     * @param _vetCenterId The ID of the veterinary center.
     * @param _doctorId The ID of the veterinarian.
     * @param _doctor The address of the veterinarian.
     */
    function regVetCenterOfficial(uint _vetCenterId, uint _doctorId, address _doctor) external {
        require(vetCenterOfficials[_vetCenterId][0] == msg.sender, "Unauthorized");
        vetCenterOfficials[_vetCenterId][_doctorId] = _doctor;
    }
}
