import { ethers } from "hardhat";
import { DogBase, DogBase__factory } from "../typechain-types";

async function main() {
    console.log("Deploing dogBase contract...");
    let dogBase: DogBase;

    const DogBaseFactory = (await ethers.getContractFactory("DogBase")) as DogBase__factory;
    dogBase = await DogBaseFactory.deploy();
    await dogBase.waitForDeployment();

    let address = [];

    for (let i = 0; i < 10; i++) {
        let [user] = await ethers.getSigners();
        address.push(user);
    }


    //Create Dogs
    const chips = [
        "123456789012345",
        "987654321098765",
        "456123789456123",
        "321654987321654",
        "789456123789456",
        "654987321654987",
        "987321456987321",
        "123789456123789",
        "456321789456321",
        "789654123789654"
    ]
    const dog_names = [
        "Max",
        "Bella",
        "Charlie",
        "Luna",
        "Rocky",
        "Daisy",
        "Buddy",
        "Maggie",
        "Oliver",
        "Sophie"
    ]
    const dog_breeds = ["Labrador Retriever", "German Shepherd", "Golden Retriever", "Bulldog", "Beagle", "Poodle", "French Bulldog", "Rottweiler", "Siberian Husky", "Dachshund"];
    const dog_sexs = ["Male", "Female"];
    const country_codes = ["US", "CA", "GB", "FR", "DE", "JP", "IN", "CN", "BR", "AU"];
    const regions = ["North America", "North America", "Europe", "Europe", "Europe", "Asia", "Asia", "Asia", "South America", "Oceania"];
    const cities = ["New York", "Toronto", "London", "Paris", "Berlin", "Tokyo", "Mumbai", "Beijing", "São Paulo", "Sydney"];
    const addresses = [
        "123 5th Ave, New York, NY 10001, USA",
        "456 Bloor St W, Toronto, ON M5S 1X8, Canada",
        "789 Oxford St, London W1D 1BS, UK",
        "10 Rue de Rivoli, 75001 Paris, France",
        "12 Kurfürstendamm, 10719 Berlin, Germany",
        "3 Chome-6-1 Shinjuku, Shinjuku City, Tokyo 160-0022, Japan",
        "15 Marine Drive, Mumbai, Maharashtra 400020, India",
        "8 Wangfujing St, Dongcheng, Beijing, 100006, China",
        "500 Av. Paulista, São Paulo - SP, 01311-000, Brazil",
        "100 George St, Sydney NSW 2000, Australia"
    ]
    const colors = ["Red", "Blue", "Green", "Yellow", "Purple", "Orange", "Black", "White", "Pink", "Gray"];
    const first_names = ["Alice", "John", "Maria", "David", "Sophia", "Michael", "Emma", "James", "Olivia", "Daniel"];
    const vetCenters = [
        {
            "name": "Manhattan Pet Care",
            "country": "US",
            "region": "North America",
            "city": "New York",
            "addr": "123 5th Ave, New York, NY 10001, USA",
            "email": "info@manhattanpetcare.com",
            "phone": "+1-212-555-1101",
            "postalCode": "10001"
        },
        {
            "name": "Toronto Pet Hospital",
            "country": "CA",
            "region": "North America",
            "city": "Toronto",
            "addr": "456 Bloor St W, Toronto, ON M5S 1X8, Canada",
            "email": "contact@torontopethospital.ca",
            "phone": "+1-416-555-1202",
            "postalCode": "M5S 1X8"
        },
        {
            "name": "London Animal Clinic",
            "country": "GB",
            "region": "Europe",
            "city": "London",
            "addr": "789 Oxford St, London W1D 1BS, UK",
            "email": "hello@londonanimalclinic.co.uk",
            "phone": "+44-20-5555-1303",
            "postalCode": "W1D 1BS"
        },
        {
            "name": "Rivoli Vet Care",
            "country": "FR",
            "region": "Europe",
            "city": "Paris",
            "addr": "10 Rue de Rivoli, 75001 Paris, France",
            "email": "support@rivilivetcare.fr",
            "phone": "+33-1-5555-1404",
            "postalCode": "75001"
        },
        {
            "name": "Berlin Pet Wellness",
            "country": "DE",
            "region": "Europe",
            "city": "Berlin",
            "addr": "12 Kurfürstendamm, 10719 Berlin, Germany",
            "email": "info@berlinpetwellness.de",
            "phone": "+49-30-5555-1505",
            "postalCode": "10719"
        },
        {
            "name": "Shinjuku Pet Hospital",
            "country": "JP",
            "region": "Asia",
            "city": "Tokyo",
            "addr": "3 Chome-6-1 Shinjuku, Shinjuku City, Tokyo 160-0022, Japan",
            "email": "contact@shinjukupethospital.jp",
            "phone": "+81-3-5555-1606",
            "postalCode": "160-0022"
        },
        {
            "name": "Marine Drive Animal Hospital",
            "country": "IN",
            "region": "Asia",
            "city": "Mumbai",
            "addr": "15 Marine Drive, Mumbai, Maharashtra 400020, India",
            "email": "info@marinedriveanimal.in",
            "phone": "+91-22-5555-1707",
            "postalCode": "400020"
        },
        {
            "name": "Dongcheng Pet Services",
            "country": "CN",
            "region": "Asia",
            "city": "Beijing",
            "addr": "8 Wangfujing St, Dongcheng, Beijing, 100006, China",
            "email": "service@dongchengpets.cn",
            "phone": "+86-10-5555-1808",
            "postalCode": "100006"
        },
        {
            "name": "Paulista Vet Clinic",
            "country": "BR",
            "region": "South America",
            "city": "São Paulo",
            "addr": "500 Av. Paulista, São Paulo - SP, 01311-000, Brazil",
            "email": "contact@paulistavetclinic.com.br",
            "phone": "+55-1155551909",
            "postalCode": "01311-000"
        },
        {
            "name": "Sydney Vet Centre",
            "country": "AU",
            "region": "Oceania",
            "city": "Sydney",
            "addr": "100 George St, Sydney NSW 2000, Australia",
            "email": "info@sydneyvetcentre.com.au",
            "phone": "+61-2-5555-2010",
            "postalCode": "2000"
        }
    ];
    const dog_vaccines = [
        "Rabies",
        "Distemper",
        "Parvovirus",
        "Adenovirus (Canine Hepatitis)",
        "Bordetella (Kennel Cough)",
        "Leptospirosis",
        "Canine Influenza",
        "Lyme Disease",
        "Coronavirus",
        "Giardia"
    ];

    const vaccine_suppliers = [
        "Zoetis",
        "Merck Animal Health",
        "Boehringer Ingelheim",
        "Elanco",
        "Merial",
        "Boehringer Ingelheim",
        "Vetoquinol",
        "Dechra Pharmaceuticals",
        "Heska",
        "Nobivac"
    ];

    const vaccine_codes = [
        "RAB-001",
        "DIS-002",
        "PAR-003",
        "ADE-004",
        "BOR-005",
        "LEP-006",
        "CAN-007",
        "LYM-008",
        "COR-009",
        "GIA-010"
    ];

    for (let i = 0; i < chips.length; i++) {
        let rand = Math.floor(0 + Math.random() * 9);



        await dogBase.regDoge(chips[i], {
            name: dog_names[Math.floor(0 + Math.random() * 9)],
            species: "dog",
            breed: dog_names[Math.floor(0 + Math.random() * 9)],
            sex: dog_names[Math.floor(0 + Math.random() * 1)],
            country: country_codes[rand],
            region: regions[rand],
            city: cities[rand],
            addr: addresses[rand],
            tatoo: "N/A",
            color: colors[Math.floor(0 + Math.random() * 9)],
            photo: "",
            postalCode: "'" + (Math.floor(100000 + Math.random() * 900000)) + "'",
            birthday: (Math.floor(Date.now() / 1000) - 1000000),
        }, {
            email: first_names[Math.floor(0 + Math.random() * 9)] + "@gmail.com",
            cellPhone: "+" + (Math.floor(10000000000 + Math.random() * 90000000000)).toString(),
            otherPhone: "+" + (Math.floor(10000000000 + Math.random() * 90000000000)).toString()
        });

        await dogBase.regVetCenter(vetCenters[i]);
    }
    for (let i = 0; i < chips.length; i++) {
        let rand = Math.floor(0 + Math.random() * 9);
        


        await dogBase.claimDogIsLost(chips[i], {
            tokenId : chips[i],
            missingDate: 0,
            postalCode: (Math.floor(100000 + Math.random() * 900000)),
            country: country_codes[rand],
            region: regions[rand],
            city: cities[rand],
            addr: addresses[rand],
        });

        await dogBase.claimDogIsFound(chips[i], {
            tokenId : chips[i],
            foundDate: 0,
            foundBy: address[Math.floor(0 + Math.random() * 9)],

        }, {
            email: first_names[Math.floor(0 + Math.random() * 9)] + "@gmail.com",
            cellPhone: "+" + (Math.floor(10000000000 + Math.random() * 90000000000)).toString(),
            otherPhone: "+" + (Math.floor(10000000000 + Math.random() * 90000000000)).toString(),
        });


        await dogBase.addVaccine(chips[i],{
            name :  dog_vaccines[i],
            supplier : vaccine_suppliers[i],
            code : vaccine_codes[i],
            vetCenterId : 0,
            date : Math.floor(Date.now() / 1000) - 1000000,
            dueDate : Math.floor(Date.now() / 1000) - 1000000,
          },0);
      
        await dogBase.addOrder(ethers.parseEther("0.01"),chips[i]);

    }


    console.log("Contract address is: " + await dogBase.getAddress());
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});