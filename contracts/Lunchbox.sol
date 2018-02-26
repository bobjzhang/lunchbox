pragma solidity ^0.4.19;

contract Lunchbox {
  address judge;
  bool internal truth = false; // Guilty or not
  uint public minPayment = 100 finney;
  uint public totalPayout;
  uint public maxEntities = 3;
  uint public numDecisions;

  // Represents a person in the jury
  struct Entity {
    uint amountPaid;
    bool verdict;
  }

  // Addresses to be paid out to after verdict is reached
  address[] internal payoutAddrs;

  // Addresses of every person part of the jury
  address[] public entitiesAddrs;
  mapping(address => Entity) entities;     

  function kill() public {
    if (msg.sender == judge) {
      selfdestruct(judge);
    }
  }

  function Lunchbox() payable public {
     judge = msg.sender;
     // Innocent until proven guilty
     truth = msg.value > 0 ? true : false;
  }

  function cleanContract() payable public {
    // TODO: Toggle the truth, I didn't get to building the judge's interface to reset the truth
    truth = !truth; 
    totalPayout = 0;
    numDecisions = 0;    
    entitiesAddrs.length = 0;
    payoutAddrs.length = 0;
  }

  // Determine if an entity needs to be added to the jury. 
  // If they are return false otherwise true.
  function hasJuryDuty(address entity) public view returns(bool) {
    for(uint i = 0; i < entitiesAddrs.length; i++) { 
      if (entitiesAddrs[i] == entity) return false;
    }
    return true;
  }  

  // Determine which entities voted the same verdict as the current truth
  // that was decided by the judge when contract was created
  // Those who had the same will be paid out.
  function carryOutVerdict(bool isGuilty) public {
    // TODO: The more an entity risks (bets) they more they get in return
    // payoutAddrs[j].transfer(entities[payoutAddrs[j]].amountPaid / totalAmountPaid * totalPayout);

    for(uint i = 0; i < entitiesAddrs.length; i++) {
      address entityAddr = entitiesAddrs[i];
      if (entities[entityAddr].verdict == isGuilty) {
        payoutAddrs.push(entityAddr);
      }
      // Delete mapping no longer needed
      delete entities[entityAddr];      
    }

    uint payoutAmount = totalPayout / payoutAddrs.length;
    for(uint j = 0; j < payoutAddrs.length; j++) {
        if (payoutAddrs[j] != address(0)) {
          payoutAddrs[j].transfer(payoutAmount);
        }
    }
    cleanContract();
  }   

  // Submit a jury entitiy's decision on guilty or not guilty.
  function makeDecision(bool isGuilty) public payable {
    assert(hasJuryDuty(msg.sender));
    assert(msg.value >= minPayment);

    entities[msg.sender].amountPaid = msg.value;
    entities[msg.sender].verdict = isGuilty;
    numDecisions += 1;
    entitiesAddrs.push(msg.sender);
    totalPayout += msg.value;

    // If we have reached the max number of allowed entities on
    // the jury, it's time for judeg to carry out verdict
    if (numDecisions >= maxEntities) carryOutVerdict(truth);
  }      

  // Fallback function in case someone sends ether to the contract so it doesn't get lost
  function() payable public {

  }   
}