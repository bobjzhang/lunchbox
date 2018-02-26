pragma solidity ^0.4.19;

// TODO: JZ make use of oraclize
// import "./usingOraclize.sol";
// import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";

contract Lunchbox {
  address judge;
  bool private truth = false; // Guilty or not
  uint public minPayment = 100 finney;
  uint public totalPayout;
  uint public maxEntities = 3;
  uint public numDecisions;

  struct Entity {
    uint amountPaid;
    bool verdict;
  }

  address[] public entitiesAddrs;
  mapping(address => Entity) entities;     

  function kill() public {
    if (msg.sender == judge) {
      selfdestruct(judge);
    }
  }

  function Lunchbox() payable public {
     judge = msg.sender;
     truth = msg.value > 0 ? true : false;
  }

  function cleanContract() payable public {
    totalPayout = 0;
    numDecisions = 0;    
    entitiesAddrs.length = 0;
  }

  function hasJuryDuty(address entity) public returns(bool) {
    for(uint i = 0; i < entitiesAddrs.length; i++) { 
      if (entitiesAddrs[i] == entity) return false;
    }
    return true;
  }  

  function carryOutVerdict(bool isGuilty) public {
    address[100] memory correctVerdicts;
    uint correctVerdictsCount = 0;

    for(uint i = 0; i < entitiesAddrs.length; i++) {
      address entityAddr = entitiesAddrs[i];
      if (entities[entityAddr].verdict == isGuilty) {
        correctVerdicts[correctVerdictsCount] = entityAddr;
        correctVerdictsCount++;
      }
      delete entities[entityAddr];
    }

    uint payoutAmount = totalPayout / correctVerdicts.length;
    for(uint j = 0; j < correctVerdicts.length; j++) {
      correctVerdicts[j].transfer(payoutAmount);
    }
    cleanContract();
  }   

  function makeDecision(bool isGuilty) public payable {
     assert(hasJuryDuty(msg.sender));
     assert(msg.value >= minPayment);

     entities[msg.sender].amountPaid = msg.value;
     entities[msg.sender].verdict = isGuilty;
     numDecisions += 1;
     entitiesAddrs.push(msg.sender);
     totalPayout += msg.value;

     if (numDecisions >= maxEntities) carryOutVerdict(truth); // Fake random true or false
  }      

  // Fallback function in case someone sends ether to the contract so it doesn't get lost
  function() payable public {

  }   
}

