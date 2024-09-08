import assert from "assert";
import { 
  TestHelpers,
  DogBase_AddVaccine
} from "generated";
const { MockDb, DogBase } = TestHelpers;

describe("DogBase contract AddVaccine event tests", () => {
  // Create mock db
  const mockDb = MockDb.createMockDb();

  // Creating mock for DogBase contract AddVaccine event
  const event = DogBase.AddVaccine.createMockEvent({/* It mocks event fields with default values. You can overwrite them if you need */});

  it("DogBase_AddVaccine is created correctly", async () => {
    // Processing the event
    const mockDbUpdated = await DogBase.AddVaccine.processEvent({
      event,
      mockDb,
    });

    // Getting the actual entity from the mock database
    let actualDogBaseAddVaccine = mockDbUpdated.entities.DogBase_AddVaccine.get(
      `${event.chainId}_${event.block.number}_${event.logIndex}`
    );

    // Creating the expected entity
    const expectedDogBaseAddVaccine: DogBase_AddVaccine = {
      id: `${event.chainId}_${event.block.number}_${event.logIndex}`,
      vacId: event.params.vacId,
      name: event.params.name,
      tokenId: event.params.tokenId,
      vetCentraId: event.params.vetCentraId,
      date: event.params.date,
    };
    // Asserting that the entity in the mock database is the same as the expected entity
    assert.deepEqual(actualDogBaseAddVaccine, expectedDogBaseAddVaccine, "Actual DogBaseAddVaccine should be the same as the expectedDogBaseAddVaccine");
  });
});
