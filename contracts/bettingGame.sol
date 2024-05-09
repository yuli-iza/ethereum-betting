pragma solidity ^ 0.4.13;
contract bettingGame {
    address public winner;

    address[7] private playerOnes;

    event diagnostic(address playerOne, address playerTwo);
    event status(uint result);

    function betMaker() public payable {
        uint8 thisBet;
        require(msg.value == 1e18 || msg.value == 2e18 || msg.value == 5e18 || msg.value == 10e18 || msg.value == 20e18 || msg.value == 50e18 || msg.value == 100e18, "Only accepting bet amounts 1, 2, 5, 10, 20, 50, or 100");

        if (msg.value == 1e18) {
            thisBet = 0;
        } else if (msg.value == 2e18) {
            thisBet = 1;
        } else if (msg.value == 5e18) {
            thisBet = 2;
        } else if (msg.value == 10e18) {
            thisBet = 3;
        } else if (msg.value == 20e18) {
            thisBet = 4;
        } else if (msg.value == 50e18) {
            thisBet = 5;
        } else { // msg.value == 100e18
            thisBet = 6;
        }

        // first player
        if (playerOnes[thisBet] == 0) {
            emit diagnostic(msg.sender, playerOnes[thisBet]);
            playerOnes[thisBet] = msg.sender;
        } else { // second player
            emit diagnostic(msg.sender, playerOnes[thisBet]);
            // pick random winner
            pseudoRandomWinner(playerOnes[thisBet]);
            playerOnes[thisBet] = 0;
        }

    }

    // Assign winner (address) and payout in function
    function pseudoRandomWinner(address player1) private {
        // Use hash of the transaction sender as a pseudo-random factor
        bytes32 randNumHash = keccak256(abi.encodePacked(msg.sender, block.timestamp));
        
        // No implementation in the case of a tie, only one winner selected
        if (uint(randNumHash) % 2 == 0) {
            winner = player1;
        } else {
            winner = msg.sender;
        }

        winner.transfer(msg.value * 2);
    }

    // Option for player to refund if there's no taker yet
    function refund(uint amountETH) public {
        require(amountETH == 1 || amountETH == 2 || amountETH == 5 || amountETH == 10 || amountETH == 20 || amountETH == 50 || amountETH == 100, "Can only refund bet amounts 1, 2, 5, 10, 20, 50, or 100");
        // index into playerOnes array
        uint8 index;
        if (amountETH == 1) {
            index = 0;
        } else if (amountETH == 2) {
            index = 1;
        } else if (amountETH == 5) {
            index = 2;
        } else if (amountETH == 10) {
            index = 3;
        } else if (amountETH == 20) {
            index = 4;
        } else if (amountETH == 50) {
            index = 5;
        } else { // amountETH == 100
            index = 6;
        }

        // if sender's address is in the array with specified amount
        if (playerOnes[index] == msg.sender) {
            msg.sender.transfer(amountETH * 1000000000000000000);
            emit status(1);
        } else {// else
            emit status(0);
        }
    }
}
