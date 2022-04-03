pragma solidity ^0.8.13;

contract marketplace {
    address owner;

    constructor() {
        owner = msg.sender;
    }
}