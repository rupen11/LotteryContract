//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract main{

    address public manager;
    address payable company;
    address payable[] public players; 

    constructor(){
        manager = msg.sender;
    }

    function alreadyEnter() private view returns(bool){
        for(uint index = 0; index < players.length; index++){
            if(players[index] == msg.sender){
                return true;
            }
        }
        return false;
    }

    function ENTER() payable public{
        require(manager != msg.sender, "You can not participate as you are manager");
        require(alreadyEnter() == false, "You already joined this contest");
        require(msg.value == 1 ether, "You have to pay fees of 1 ether for joining contest");
        players.push(payable(msg.sender));
    }

    function random() view private returns(uint){
        return uint(sha256(abi.encodePacked(block.difficulty, block.number, players)));
    }
    
    function pickWinner() public{
        require(players.length != 0, "Contest not start yet!");
        require(manager == msg.sender, "You can not access");
        uint index = random()%players.length;
        company.transfer(1 ether); // 1ether to compnay to organizing this amazing contest
        players[index].transfer(address(this).balance);
        players = new address payable[](0); //reset players
    }

    function getPlayers() view public returns(address payable[] memory){
        return players;
    }

    function checkBalance() view public returns(uint){
        return address(this).balance;
    }

}