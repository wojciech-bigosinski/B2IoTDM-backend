pragma solidity ^0.8.13;

contract marketplace {
    address owner;

    constructor() {
        owner = msg.sender;
    }

    mapping(address => bool) registeredPublishers;
    mapping(address => string) publisherName;
    mapping(address => uint256) publisherScore;

    struct offer {
        address publisher;
        string metadata;
        mapping(address => bool) boughtAccess;
        uint256[] reviews;
        uint256 price;
        string sample;
        string data;
        string[] dataArray;
    }
}