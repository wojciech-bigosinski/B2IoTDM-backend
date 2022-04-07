// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.13;

contract marketplace {
    address owner;

    constructor() 
    {
        owner = msg.sender;
    }
    
    mapping(address => uint256) internal publishersStakes;
    mapping(address => uint256) publishersOffers;
    mapping(address => uint256) publishersRatings;
    mapping(address => uint256) publishersNumberOfRatings;
    mapping(address => string) publishersNames;
    

    struct offer 
    {
        address publisher;
        uint256 id;
        string metadata;
        mapping(address => purchase) boughtAccess;
        uint256[] reviews;
        uint256 price;
        string sample;
        string data;
        string[] dataArray;
    }

    struct purchase
    {
        address buyer;
        address publisher;
        uint256 offerId;
        uint timestamp;
        string key;
    }

    offer[] offers;

    error NotEnoughEther();

    function registerPublisher() public payable
    {
        if (msg.value < 1e15) revert NotEnoughEther();
        address publisher = msg.sender;
        publishersStakes[publisher] += msg.value;
    }

    function unregisterPublisher() public 
    {
        address publisher = msg.sender;
        uint256 publisherStake = publishersStakes[publisher];
        if (publisherStake == 0) revert NotEnoughEther();
        publishersStakes[publisher] = 0;
        payable(msg.sender).transfer(publisherStake);
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

    function writeReview(address publisher, uint256 id) public returns(bool)
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

    function depositPayment(address publisher, uint256 id) public payable returns(bool)
    {

    }

    function sendKey(address buyer, string memory key) public returns(bool)
    {

    }

    function readKey() public view returns(string memory)
    {

    }

}