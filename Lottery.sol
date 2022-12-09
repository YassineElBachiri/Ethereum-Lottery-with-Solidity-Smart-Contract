// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Lottery {
    address payable[] public players;
    address payable public admin;

    constructor() {
        admin = payable(msg.sender);
    }

    receive() external payable {
        require(msg.value == 1 ether,'Must be exactly 1 ether');
        require(msg.sender != admin ,'Ooops! Admin can not plays');

        players.push(payable (msg.sender));
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance; //returns the contract balance
    }

    function random() internal view returns (uint256) {
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,players.length)));
    }

    function pickWinner() public {
        require(admin == msg.sender , 'You Are Not The Owner');
        require( players.length >= 3 , 'Not Enough Players Participating in the lottery');
        address payable winner;

        winner = players[ random() % players.length];
        winner.transfer(getBalance());

        players = new address payable[](0);
    }
}
