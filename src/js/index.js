import React from 'react';
import ReactDOM from 'react-dom';
import Web3 from 'web3';
import '../css/index.css';
import initializeWeb3 from '../utils/initializeWeb3';
import { contractAddress, ABIInterface } from '../constants/solidityConstants';

class App extends React.Component {
   constructor(props) {
      super(props);
      this.state = {
         numDecisions: 0,
         minPayment: 0,
         totalPayout: 0,
         maxEntities: 0,
         web3: null,
      };

      initializeWeb3.then(response => {
         this.setState({ web3: response.web3 });
         this.instantiateContract();
         this.updateState();
         this.addListeners();
         setInterval(this.updateState.bind(this), 10e3);         
      }).catch(() => {
         console.log('web3 Not Found');
      });
   }

   instantiateContract() {
      const MyContract = this.state.web3.eth.contract(ABIInterface);
      this.state.ContractInstance = MyContract.at(contractAddress);
   }

   updateState(){
      this.state.ContractInstance.minPayment((err, data) => {
         if (data != null) {
            this.setState({ minPayment: parseFloat(this.state.web3.fromWei(data, 'ether'))});
         }
      });

      this.state.ContractInstance.totalPayout((err, data) => {
         if (data != null) {
            this.setState({ totalPayout: parseFloat(this.state.web3.fromWei(data, 'ether')) });
         }
      });

      this.state.ContractInstance.numDecisions((err, data) => {
         if (data != null) {
            this.setState({ numDecisions: parseInt(data) });
         }
      });

      this.state.ContractInstance.maxEntities((err, data) => {
         if (data != null) {
            this.setState({ maxEntities: parseInt(data) });
         }
      });
   }

   addListeners(){
      let buttons = this.refs.voteButtons.querySelectorAll('button');
      buttons.forEach((button) => {
         button.addEventListener('click', event => {
            const verdict = event.target.innerHTML.toString() === 'Guilty' ? true : false;
            this.carryOutDecision(verdict, done => {
               buttons[0].className = 'verdict-button--disabled';
               buttons[1].className = 'verdict-button--disabled';
            });
         });
      });
   }

   carryOutDecision(verdict){
      let payment = this.refs['payment'].value
      if (!payment) payment = 0.1;
      if (parseFloat(payment) < this.state.minPayment) {
         alert('Minimum payment cost to participate is this.state.minPayment');
      } else {
         const decision = {
            gas: 300000,
            from: this.state.web3.eth.accounts[0],
            value: this.state.web3.toWei(payment, 'ether')
         };
         console.log(`[SUCCESS]Decision: ${verdict}`);
         this.state.ContractInstance.makeDecision(verdict, decision, (err, transactionId) => {
            console.log(`[SUCCESS]Transaction ID: ${transactionId}`);
         });
      }
   }

   render(){
      return (
         <div className="container">
            <h1>You are the jury, Decide if they are guilty and bet ether on it.</h1>
            <div className="u-flexContainer u-alignCenter">
               <p className="u-bold">Minimum payment amount to participate:</p> &nbsp;
               <span>{this.state.minPayment} ether</span>
            </div>            
            <div className="u-flexContainer u-alignCenter">
               <p className="u-bold">Number of jury already decided:</p>&nbsp;
               <span>{this.state.numDecisions}</span>
            </div>
            <div className="u-flexContainer u-alignCenter">
               <p className="u-bold">Total payout:</p> &nbsp;
               <span>{this.state.totalPayout} ether</span>
            </div>
            <div className="u-flexContainer u-alignCenter">
               <p className="u-bold">Max Number of participants allowed:</p> &nbsp;
               <span>{this.state.maxEntities} ether</span>
            </div>             
            <hr/>
            <div className="u-flexContainer u-flexColumn u-alignCenter u-justifyCenter">
               <h3>Enter the amount of Ether you want to stake for the outcome of this trial?</h3>
               <input className="payment-field" ref="payment" type="number" placeholder={this.state.minPayment}/>
               <div className="u-flexContainer u-marginTop" ref="voteButtons">
               <button className="verdict-button u-marginRight">Innocent</button>
                  <button className="verdict-button">Guilty</button>
               </div>
            </div>
         </div>
      )
   }
}

ReactDOM.render(
   <App />,
   document.querySelector('#root')
)
