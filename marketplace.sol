// SPDX-License-Identifier: UNLICENSED

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
        uint256 id;
        string metadata;
        mapping(address => bool) boughtAccess;
        mapping(address => string) key;
        uint256[] reviews;
        uint256 price;
        string sample;
        string data;
        string[] dataArray;
    }

    offer[] offers;

    function registerPublisher() public payable returns(bool)
    {

    }

    function setOffer(string memory metadata, uint256 price, string memory sample, string memory data) public returns(bool) 
    {

    }

    function addDataToOffer(uint256 id) public returns(bool) 
    {

    }

    function getOffer(address publisher, uint256 id) public view returns(string memory, uint256, string memory, string memory, string[] memory)
    {

    }

    function getOffers() public view returns(string[] memory, uint256[] memory, string[] memory, string[] memory, string[][] memory)
    {

    }

    function setReview(address publisher, uint256 id) public returns(bool)
    {

    }

    function checkIfCanReview(address publisher, uint256 id) internal returns(bool)
    {

    }

    function checkPublisherScore(address publisher) internal
    {

    }

    function slashPublisher(address publisher) internal
    {

    }

    function depositPayment(address publisher, uint256 id) public returns(bool)
    {

    }

    function sendKey(address buyer, string memory key) public returns(bool)
    {

    }

    function readKey() public view returns(string memory)
    {

    }

}