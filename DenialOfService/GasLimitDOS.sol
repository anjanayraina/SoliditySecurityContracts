// Even if your contract does not contain an unbounded loop, an attacker can prevent other transactions from being included in the blockchain for several blocks by placing computationally intensive transactions with a high enough gas price.

// To do this, the attacker can issue several transactions which will consume the entire gas limit, with a high enough gas price to be included as soon as the next block is mined. No gas price can guarantee inclusion in the block, but the higher the price is, the higher is the chance.

// If the attack succeeds, no other transactions will be included in the block. Sometimes, an attacker's goal is to block transactions to a specific contract prior to specific time.

// This attack was conducted on Fomo3D, a gambling app. The app was designed to reward the last address that purchased a "key". Each key purchase extended the timer, and the game ended once the timer went to 0. The attacker bought a key and then stuffed 13 blocks in a row until the timer was triggered and the payout was released. Transactions sent by attacker took 7.9 million gas on each block, so the gas limit allowed a few small "send" transactions (which take 21,000 gas each), but disallowed any calls to the buyKey() function (which costs 300,000+ gas).

// A Block Stuffing attack can be used on any contract requiring an action within a certain time period. However, as with any attack, it is only profitable when the expected reward exceeds its cost. The cost of this attack is directly proportional to the number of blocks which need to be stuffed. If a large payout can be obtained by preventing actions from other participants, your contract will likely be targeted by such an attack.


struct Payee {
    address addr;
    uint256 value;
}

Payee[] payees;
uint256 nextPayeeIndex;

function payOut() {
    uint256 i = nextPayeeIndex;
    while (i < payees.length && gasleft() > 200000) {
      payees[i].addr.send(payees[i].value);
      i++;
    }
    nextPayeeIndex = i;
}
