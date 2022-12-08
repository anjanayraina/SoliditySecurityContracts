
contract SecureDOSAttack{
    SecureDOS targetContract;
    constructor(address _target) payable  {
        targetContract = SecureDOS(_target);
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


contract SecureDOS{
 address payable public highestBidder;
    uint public  highestBid;
    mapping(address => uint) refund;

    constructor() payable {
        highestBidder = payable(msg.sender);
        highestBid = msg.value;
    }

    function bidAmount()public  payable{
     uint amount = msg.value;
     refund[msg.sender] += amount;
        if(amount > highestBid){ 
            highestBid = amount;
            highestBidder = payable(msg.sender);
        }

    }

    function issueRefund() external{
        uint amount = refund[msg.sender];
        refund[msg.sender] =0;
        bool success;
        if(amount > 0)
        {
           (success , )= msg.sender.call{value :amount }("");
         } 

         if(!success){
             refund[msg.sender] = amount;
         }
    }

}

// to secure against a DOS attack,  you can seperate the refund and the bidding functions 
// so that the transactions can take place seperate from each other and DOS is mitigrated 