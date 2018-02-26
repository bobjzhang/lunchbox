pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Lunchbox.sol";

contract TestLunchbox {
  function testInitialValuesWithNewTrial() public {
    Lunchbox trial = new Lunchbox();
    uint expectedMinPayment = 100 finney;
    Assert.equal(trial.minPayment(), expectedMinPayment, "minPayment should have been initialized correct to 0.1");
    Assert.equal(trial.totalPayout(), uint(0), "totalPayout should have been initialized correct to 0");
    Assert.equal(trial.maxEntities(), uint(3), "maxEntities should have been initialized correct to 3");
    Assert.equal(trial.numDecisions(), uint(0), "numDecisions should have been initialized correct to 0");  
    // TODO: Can't test private/internal
    // Assert.equal(trial.payoutAddrs.length, uint(0), "payoutAddrs arrays should have been initialized correct to empty arays of length 0");
    // Assert.equal(trial.entitiesAddrs().length, uint(0), "entitiesAddrs arrays should have been initialized correct to empty arays of length 0");
    // Assert.equal(trial.entities().length, uint(0), "entities arrays should have been initialized correct to empty arays of length 0");    
  }  

  function testHasJuryDutyFunctionWithNewTrial() public {
    Lunchbox trial = new Lunchbox();
    address testEntityAddr = 0x95d18D19545ebf93b2b1d8DB5FB93681154A6c9f;
    Assert.equal(trial.hasJuryDuty(testEntityAddr), true, "If an entity is no part of the entitiesAddrs array they should have jury duty");

    // TODO: Can't test private/internal payoutAddrs
    // trial.payoutAddrs().push(testEntityAddr);
    // Assert.equal(trial.hasJuryDuty(testEntityAddr), false, "If an entity has been processed they should no longer still have jury duty");
  }  

  function testMakeDecisionFunctionWithNewTrial() public {
    Lunchbox trial = new Lunchbox();
    trial.makeDecision(true);
    trial.makeDecision(false);
  }    

  // function testCarryOutVerdictFunctionWithNewTrial() public {
  //   Lunchbox trial = new Lunchbox();
  // }    

  // function testCleanContractFunctionWithNewTrial() public {
  //   Lunchbox trial = new Lunchbox();
  // }      
}
