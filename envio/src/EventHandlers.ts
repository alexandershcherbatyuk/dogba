/*
 * Please refer to https://docs.envio.dev for a thorough guide on all Envio indexer features
 */
import {
  DogBase,
  DogBase_AddVaccine,
  DogBase_Approval,
  DogBase_ApprovalForAll,
  DogBase_DogIsFound,
  DogBase_DogIsLost,
  DogBase_NewDoge,
  DogBase_OwnershipTransferred,
  DogBase_Transfer,
} from "generated";

DogBase.AddVaccine.handler(async ({ event, context }) => {
  const entity: DogBase_AddVaccine = {
    id: `${event.chainId}_${event.block.number}_${event.logIndex}`,
    vacId: event.params.vacId,
    name: event.params.name,
    tokenId: event.params.tokenId,
  };

  context.DogBase_AddVaccine.set(entity);
});


DogBase.Approval.handler(async ({ event, context }) => {
  const entity: DogBase_Approval = {
    id: `${event.chainId}_${event.block.number}_${event.logIndex}`,
    owner: event.params.owner,
    approved: event.params.approved,
    tokenId: event.params.tokenId,
  };

  context.DogBase_Approval.set(entity);
});


DogBase.ApprovalForAll.handler(async ({ event, context }) => {
  const entity: DogBase_ApprovalForAll = {
    id: `${event.chainId}_${event.block.number}_${event.logIndex}`,
    owner: event.params.owner,
    operator: event.params.operator,
    approved: event.params.approved,
  };

  context.DogBase_ApprovalForAll.set(entity);
});


DogBase.DogIsFound.handler(async ({ event, context }) => {
  const entity: DogBase_DogIsFound = {
    id: `${event.chainId}_${event.block.number}_${event.logIndex}`,
    tokenId: event.params.tokenId,
    name: event.params.name,
  };

  context.DogBase_DogIsFound.set(entity);
});


DogBase.DogIsLost.handler(async ({ event, context }) => {
  const entity: DogBase_DogIsLost = {
    id: `${event.chainId}_${event.block.number}_${event.logIndex}`,
    tokenId: event.params.tokenId,
    name: event.params.name,
  };

  context.DogBase_DogIsLost.set(entity);
});


DogBase.NewDoge.handler(async ({ event, context }) => {
  const entity: DogBase_NewDoge = {
    id: `${event.chainId}_${event.block.number}_${event.logIndex}`,
    tokenId: event.params.tokenId,
    name: event.params.name,
  };

  context.DogBase_NewDoge.set(entity);
});


DogBase.OwnershipTransferred.handler(async ({ event, context }) => {
  const entity: DogBase_OwnershipTransferred = {
    id: `${event.chainId}_${event.block.number}_${event.logIndex}`,
    previousOwner: event.params.previousOwner,
    newOwner: event.params.newOwner,
  };

  context.DogBase_OwnershipTransferred.set(entity);
});


DogBase.Transfer.handler(async ({ event, context }) => {
  const entity: DogBase_Transfer = {
    id: `${event.chainId}_${event.block.number}_${event.logIndex}`,
    from: event.params.from,
    to: event.params.to,
    tokenId: event.params.tokenId,
  };

  context.DogBase_Transfer.set(entity);
});

