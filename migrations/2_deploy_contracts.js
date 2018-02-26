var Lunchbox = artifacts.require("../contracts/Lunchbox.sol");

module.exports = function(builder) {
  builder.deploy(web3.toWei(0.1, 'ether'), 100, {gas: 3000000});
};