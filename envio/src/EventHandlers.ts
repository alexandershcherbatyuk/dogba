import { UserDogs_t } from '../generated/src/db/Entities.gen';
/*
 * Please refer to https://docs.envio.dev for a thorough guide on all Envio indexer features
 */
import {
  DogBase,
  DogBase_AddVaccine,
  DogBase_Approval,
  DogBase_ApprovalForAll,
  DogBase_CenterVet,
  DogBase_ConfirmDogFound,
  DogBase_ConfitmMarketPlaceOrder,
  DogBase_DogIsFound,
  DogBase_DogIsLost,
  DogBase_MarketPlace,
  DogBase_NewDoge,
  DogBase_OwnershipTransferred,
  DogBase_Transfer,
} from 'generated';

DogBase.AddVaccine.handler(async ({ event, context }) => {
  const entity: DogBase_AddVaccine = {
    id: `${event.chainId}_${event.block.number}_${event.logIndex}`,
    vacId: event.params.vacId,
    name: event.params.name,
    tokenId: event.params.tokenId,
    vetCentraId: event.params.vetCentraId,
    date: event.params.date,
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

DogBase.CenterVet.handler(async ({ event, context }) => {
  const entity: DogBase_CenterVet = {
    id: `${event.chainId}_${event.block.number}_${event.logIndex}`,
    vetCentraId: event.params.vetCentraId,
    name: event.params.name,
  };

  context.DogBase_CenterVet.set(entity);
});

DogBase.ConfirmDogFound.handler(async ({ event, context }) => {
  const entity: DogBase_ConfirmDogFound = {
    id: `${event.chainId}_${event.block.number}_${event.logIndex}`,
    tokenId: event.params.tokenId,
  };

  context.DogBase_ConfirmDogFound.set(entity);
});

DogBase.ConfitmMarketPlaceOrder.handler(async ({ event, context }) => {
  const entity: DogBase_ConfitmMarketPlaceOrder = {
    id: `${event.chainId}_${event.block.number}_${event.logIndex}`,
    tokenId: event.params.tokenId,
    orderId: event.params.orderId,
  };

  context.DogBase_ConfitmMarketPlaceOrder.set(entity);
});

DogBase.DogIsFound.handler(async ({ event, context }) => {
  const entity: DogBase_DogIsFound = {
    id: `${event.chainId}_${event.block.number}_${event.logIndex}`,
    tokenId: event.params.tokenId,
    addr: event.params.addr,
    date: event.params.date,
  };

  context.DogBase_DogIsFound.set(entity);
});

DogBase.DogIsLost.handler(async ({ event, context }) => {
  const entity: DogBase_DogIsLost = {
    id: `${event.chainId}_${event.block.number}_${event.logIndex}`,
    tokenId: event.params.tokenId,
    addr: event.params.addr,
    date: event.params.date,
  };

  context.DogBase_DogIsLost.set(entity);
});

DogBase.MarketPlace.handler(async ({ event, context }) => {
  const entity: DogBase_MarketPlace = {
    id: `${event.chainId}_${event.block.number}_${event.logIndex}`,
    tokenId: event.params.tokenId,
    price: event.params.price,
    orderId: event.params.orderId,
  };

  context.DogBase_MarketPlace.set(entity);
});

DogBase.NewDoge.handler(async ({ event, context }) => {
  const entity: DogBase_NewDoge = {
    id: `${event.chainId}_${event.block.number}_${event.logIndex}`,
    tokenId: event.params.tokenId,
    name: event.params.name,
    birthday: event.params.birthday,
    breed: event.params.breed,
    sex: event.params.sex,
    owner: event.params.owner,
  };

  context.DogBase_NewDoge.set(entity);

  let curUserDogs = await context.UserDogs.get(event.params.owner);
  if (curUserDogs) {
    curUserDogs?.dogsId.push(event.params.tokenId);
  } else {
    curUserDogs = {
      id: event.params.owner,
      owner: event.params.owner,
      dogsId: [event.params.tokenId],
    };
  }
  context.UserDogs.set(curUserDogs);
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

  let fromUserDogs = await context.UserDogs.get(event.params.from);
  if (fromUserDogs) {
    fromUserDogs?.dogsId.filter((elem) => elem != event.params.tokenId);
  } else {
    fromUserDogs = {
      id: event.params.from,
      owner: event.params.from,
      dogsId: [],
    };
  }
  context.UserDogs.set(fromUserDogs);

  let toUserDogs = await context.UserDogs.get(event.params.to);
  if (toUserDogs) {
    toUserDogs?.dogsId.push(event.params.tokenId);
  } else {
    toUserDogs = {
      id: event.params.from,
      owner: event.params.from,
      dogsId: [event.params.tokenId],
    };
  }
  context.UserDogs.set(toUserDogs);
});
