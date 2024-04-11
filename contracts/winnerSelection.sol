pragma solidity ^ 0.4.13;
contract bettingGame {
    address public player1;
    address public player2;
    bool public paymentPlayer1;
    bool public paymentPlayer2;
    address public winner;

    // Assign winner (address) and payout in function
    function pseudoRandomWinner() private {
        // If payment from both player 1 and 2 is not true then terminate
        // Cases: bets werent properly placed, or player did not have sufficient balance 
        require(paymentPlayer1 && paymentPlayer2, "Bets have not been placed");
        
        // Use hash of the transaction sender as a pseudo-random factor
        bytes32 randNumHash = keccak256(abi.encodePacked(msg.sender, block.timestamp));
        
        // No implementation in the case of a tie, only one winner selected
        if (uint(randNumHash) % 2 == 0) {
            winner = player1;
        } else {
            winner = player2;
        }

        // Once winner is determined payout
        address winnerAddress = winner;
        winnerAddress.transfer(address(this).balance);
    }
}
