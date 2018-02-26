# lunchbox

Description
================================
* I was trying to create something that wasn't the generic gambling or voting game that I came across in many tutorials.
* The goal of this was to mock a trial system, but it quickly became a betting style game such that jury bets to convict the defendent. Ran out of time to really build out the bulk of this, but might come back to it.

Pre-requisites
================================
* Start a testrpc server running locally on 8545 as a fallback if we can't get web3 context from your metamask profile
* Requires metamask extension running for web3 integration

Set-up
================================
* Enable metamask chrome plugin and switch to `Ropsten Test Net`
* Get some fake ether at https://faucet.metamask.io/ to play with
* Clone the repo
* Run `yarn` in root directory of Lunchbox
* Run `./node_modules/webpack/bin/webpack.js` in root directory of Lunchbox to build the React and css
* Run `./node_modules/webpack/bin/http-server` 
* Go to `localhost:8080/dist` to see the app loaded
* You are now ready to place your verdict

Alternative
================================
* Go to https://remix.ethereum.org/ and load the contract currently deployed to `0x85530a567ed0b61925695983c22df9bf6b570bdb`
* This should give you access to the full code for Lunchbox

What I didn't get around to doing
=================================
* Hosting on IPFS - because I afraid of danger
* Making the jude's interface to determine all the juries votings

Some gotcha's I learned
=================================
* For web3 to locally I needed to host the react app properly (i.e via http server)
* Need the load even listener to avoid race conditions
* remix is flaky and need to clear cache