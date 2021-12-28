pragma solidity ^0.4.17;

contract Lottery {
    address public manager;
    address[] public players;

    function Lottery() public {
        //collect the address of who created/sent the lottery contract
        //msg is a global varaiable for all transactions - sender value gives address
        manager = msg.sender;
    }

    function enter() public payable {
        //get amount of ETH player sent in and check if the amount of ETH is more than .01 ETH
        //require is a golbal function that will stop/continue the function based on the bool value
        //msg.value gets the (ETH) value that the sender is sending
        require(msg.value > .01 ether);

        //add player address to players array
        players.push(msg.sender);
    }

    //random number generator
    function random() private view returns (uint256) {
        return uint256(keccak256(block.difficulty, now, players));
    }

    function pickWinner() public restricted {
        //get the index of the winner
        uint256 index = random() % players.length;
        //get the address of the winner
        //transfer() sends money to address
        //this is a reference to the current contract
        //balance is a reference to the amount of monry in the contract
        players[index].transfer(this.balance);

        //after a winner is picked empty/reset players Array with a length of 0
        players = new address[](0);
    }

    modifier restricted() {
        //check that the manager calling the function
        require(msg.sender == manager);
        _;
    }

    //return all players in the lottery
    function getPlayers() public view returns (address[]) {
        return players;
    }
}
