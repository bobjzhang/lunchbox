import Web3 from 'web3'

let initializeWeb3 = new Promise(function(resolve, reject) {
  window.addEventListener('load', function() {
    let web3 = window.web3;

    // Checking if Web3 has been injected by the browser (MetaMask)
    if (typeof web3 !== 'undefined') {
      web3 = new Web3(web3.currentProvider)
    } else {
      let provider = new Web3.providers.HttpProvider("http://localhost:8545");
      web3 = new Web3(provider)
      return web3;
    }
    resolve({ web3: web3 });
  })
})

export default initializeWeb3;