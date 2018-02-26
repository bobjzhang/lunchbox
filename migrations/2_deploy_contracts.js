var MockTrial = artifacts.require("../contracts/MockTrial.sol");
const maxEntities = 10;
module.exports = function(builder) {
  builder.deploy(web3.toWei(0.1, 'ether'), maxEntities, {gas: 3000000});
};