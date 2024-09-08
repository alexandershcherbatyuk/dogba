import { ethers } from "hardhat";
import { expect } from "chai";
import { Signer } from "ethers";
import { DogBase, DogBase__factory } from "../typechain-types";

describe("DogBase Contract", function () {
    let dogBase: DogBase;
    let owner: Signer;
    let addr1: Signer;
    let addr2: Signer;

    beforeEach(async function () {
        [owner, addr1, addr2] = await ethers.getSigners();

        const DogBaseFactory = (await ethers.getContractFactory("DogBase")) as DogBase__factory;
        dogBase = await DogBaseFactory.deploy();
        await dogBase.waitForDeployment();
    });

    it("Should register a new dog", async function () {
        const dog = {
            name: "Rex",
            species: "Dog",
            breed: "Labrador",
            sex: "Male",
            country: "USA",
            region: "CA",
            city: "Los Angeles",
            addr: "123 Dog Street",
            tatoo: "1234ABCD",
            color: "Black",
            photo: "photo_url",
            postalCode: "90001",
            birthday: Math.floor(Date.now() / 1000) - 1000000
        };

        const contact = {
            email: "owner@example.com",
            cellPhone: "123-456-7890",
            otherPhone: "098-765-4321"
        };

        await dogBase.connect(owner).regDoge(1, dog, contact);

        const registeredDog = await dogBase.dogs(1);
        expect(registeredDog.name).to.equal(dog.name);
    });

    it("Should emit NewDoge event on dog registration", async function () {
        const dog = {
            name: "Rex",
            species: "Dog",
            breed: "Labrador",
            sex: "Male",
            country: "USA",
            region: "CA",
            city: "Los Angeles",
            addr: "123 Dog Street",
            tatoo: "1234ABCD",
            color: "Black",
            photo: "photo_url",
            postalCode: "90001",
            birthday: Math.floor(Date.now() / 1000) - 1000000
        };

        const contact = {
            email: "owner@example.com",
            cellPhone: "123-456-7890",
            otherPhone: "098-765-4321"
        };

        await expect(dogBase.connect(owner).regDoge(1, dog, contact))
            .to.emit(dogBase, "NewDoge")
            .withArgs(1, dog.name);
    });

    it("Should claim a dog as lost", async function () {
        const dog = {
            name: "Rex",
            species: "Dog",
            breed: "Labrador",
            sex: "Male",
            country: "USA",
            region: "CA",
            city: "Los Angeles",
            addr: "123 Dog Street",
            tatoo: "1234ABCD",
            color: "Black",
            photo: "photo_url",
            postalCode: "90001",
            birthday: Math.floor(Date.now() / 1000) - 1000000
        };

        const contact = {
            email: "owner@example.com",
            cellPhone: "123-456-7890",
            otherPhone: "098-765-4321"
        };

        const lostDog = {
            missingDate: Math.floor(Date.now() / 1000),
            postalCode: "90001",
            country: "USA",
            region: "CA",
            city: "Los Angeles",
            addr: "123 Dog Street"
        };

        await dogBase.connect(owner).regDoge(1, dog, contact);
        await dogBase.connect(owner).claimDogIsLost(1, lostDog);
        const lostDogs = await dogBase.lostDogs(1,0);
 
        expect(lostDogs.length).to.greaterThan(1);
        expect(lostDogs.missingDate).to.be.closeTo(lostDog.missingDate, 60);
    });

    it("Should claim a dog as found", async function () {
        const dog = {
            name: "Rex",
            species: "Dog",
            breed: "Labrador",
            sex: "Male",
            country: "USA",
            region: "CA",
            city: "Los Angeles",
            addr: "123 Dog Street",
            tatoo: "1234ABCD",
            color: "Black",
            photo: "photo_url",
            postalCode: "90001",
            birthday: Math.floor(Date.now() / 1000) - 1000000
        };

        const contact = {
            email: "owner@example.com",
            cellPhone: "123-456-7890",
            otherPhone: "098-765-4321"
        };

        const foundDog = {
            foundDate: Math.floor(Date.now() / 1000),
            foundBy: await addr1.getAddress()
        };

        await dogBase.connect(owner).regDoge(1, dog, contact);
        await dogBase.connect(addr1).claimDogIsFound(1, foundDog, contact);

        const foundDogs = await dogBase.foundDogs(1,0);
        expect(foundDogs.length).to.greaterThan(1);
        expect(foundDogs.foundBy).to.equal(await addr1.getAddress());
    });

    it("Should regestrate a VetCenter", async function () {
        const vetCenter = {
            
                "name": "Sydney Vet Centre",
                "country": "AU",
                "region": "Oceania",
                "city": "Sydney",
                "addr": "100 George St, Sydney NSW 2000, Australia",
                "email": "info@sydneyvetcentre.com.au",
                "postalCode": "2000",
                "phone": "+61-2-5555-2010"
            
        };

        await dogBase.connect(owner).regVetCenter(vetCenter);
        const  vetCenters = await dogBase.vetCenters(0);
        expect(vetCenters.length).to.greaterThan(1);
        expect(vetCenters.name).to.equal(vetCenter.name);
    });

    it("Should add vaccine information", async function () {
        const dog = {
            name: "Rex",
            species: "Dog",
            breed: "Labrador",
            sex: "Male",
            country: "USA",
            region: "CA",
            city: "Los Angeles",
            addr: "123 Dog Street",
            tatoo: "1234ABCD",
            color: "Black",
            photo: "photo_url",
            postalCode: "90001",
            birthday: Math.floor(Date.now() / 1000) - 1000000
        };

        const contact = {
            email: "owner@example.com",
            cellPhone: "123-456-7890",
            otherPhone: "098-765-4321"
        };

        const vaccine = {
            name: "Rabies",
            supplier: "VetCo",
            code: "R1234",
            vetCenterId: 0,
            date: Math.floor(Date.now() / 1000),
            dueDate: Math.floor(Date.now() / 1000) + 31536000 // 1 year later
        };

        const vetCenter = {
            
            "name": "Sydney Vet Centre",
            "country": "AU",
            "region": "Oceania",
            "city": "Sydney",
            "addr": "100 George St, Sydney NSW 2000, Australia",
            "email": "info@sydneyvetcentre.com.au",
            "postalCode": "2000",
            "phone": "+61-2-5555-2010"
        
        };
        await dogBase.connect(owner).regVetCenter(vetCenter);
        await dogBase.connect(owner).regDoge(1, dog, contact);
        await dogBase.connect(owner).addVaccine(1, vaccine, 0);

        const vaccines = await dogBase.vaccines(1,0);

        expect(vaccines.length).to.greaterThan(1);
        expect(vaccines.name).to.equal(vaccine.name);
    });

    it("Should reward the finder of a dog", async function () {
        const dog = {
            name: "Rex",
            species: "Dog",
            breed: "Labrador",
            sex: "Male",
            country: "USA",
            region: "CA",
            city: "Los Angeles",
            addr: "123 Dog Street",
            tatoo: "1234ABCD",
            color: "Black",
            photo: "photo_url",
            postalCode: "90001",
            birthday: Math.floor(Date.now() / 1000) - 1000000
        };

        const contact = {
            email: "owner@example.com",
            cellPhone: "123-456-7890",
            otherPhone: "098-765-4321"
        };

        const foundBy = await addr1.getAddress();

        await dogBase.connect(owner).regDoge(1, dog, contact);
        await dogBase.connect(owner).claimDogIsLost(1, {
            missingDate: Math.floor(Date.now() / 1000),
            postalCode: "90001",
            country: "USA",
            region: "CA",
            city: "Los Angeles",
            addr: "123 Dog Street"
        });

        const balanceBefore = await ethers.provider.getBalance(foundBy);
        await dogBase.connect(owner).payReward(1, foundBy, { value: ethers.parseEther("0.001") });

        const balance = await ethers.provider.getBalance(foundBy);
        expect(balance).to.be.greaterThanOrEqual((balanceBefore+ethers.toBigInt(ethers.parseEther("0.001"))));
    });

    it("Should register a vet center and official", async function () {
        const vetCenter = {
            name: "Vet Clinic",
            country: "USA",
            region: "CA",
            city: "Los Angeles",
            addr: "456 Vet Lane",
            email: "clinic@example.com",
            phone: "321-654-0987",
            postalCode: "90002"
        };

        // Register a vet center
        await dogBase.connect(owner).regVetCenter(vetCenter);

        // Retrieve the registered vet center
        const registeredVetCenter = await dogBase.vetCenters(0);
        expect(registeredVetCenter.name).to.equal(vetCenter.name);
        expect(registeredVetCenter.email).to.equal(vetCenter.email);

        // Register a vet center official
        await dogBase.connect(owner).regVetCenterOfficial(0, 1, await addr1.getAddress());

        // Verify the vet center official
        const official = await dogBase.vetCenterOfficials(0, 1);
        expect(official).to.equal(await addr1.getAddress());
    });

    it("Should add an order to the market", async function () {
        const dog = {
            name: "Rex",
            species: "Dog",
            breed: "Labrador",
            sex: "Male",
            country: "USA",
            region: "CA",
            city: "Los Angeles",
            addr: "123 Dog Street",
            tatoo: "1234ABCD",
            color: "Black",
            photo: "photo_url",
            postalCode: "90001",
            birthday: Math.floor(Date.now() / 1000) - 1000000
        };

        const contact = {
            email: "owner@example.com",
            cellPhone: "123-456-7890",
            otherPhone: "098-765-4321"
        };

        await dogBase.connect(owner).regDoge(1, dog, contact);
        
        // Add an order for the dog
        await dogBase.connect(owner).addOrder(ethers.parseEther("0.01"), 1);

        // Retrieve the market orders
        const orders = await dogBase.market(0);
        expect(orders.tokenId).to.equal(1);
        expect(orders.price).to.equal(ethers.parseEther("0.01"));
    });
});