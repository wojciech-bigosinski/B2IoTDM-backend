// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.13;

contract marketplace {
    address owner;
    uint256 balance;

    constructor() 
    {
        owner = msg.sender;
        balance = 0;
    }
    
    mapping(address => uint256) internal publishersStakes;
    mapping(address => uint256) publishersOffers;
    mapping(address => uint256) publishersRating;
    mapping(address => uint256) publishersNumberOfRatings;
    mapping(address => string) publishersNames;
    

    struct purchase
    {
        address buyer;
        uint256 offerId;
        uint timestamp;
        string key;
    }

    struct offer 
    {
        address publisher;
        uint256 id;
        string metadata;
        mapping(uint => purchase) purchases;
        uint purchasesSize;
        mapping(address => bool) canReview;
        string[] reviews;
        uint[] ratings;
        uint rating;
        uint256 price;
        string sample;
        string data;
        string[] dataArray;
    }

    mapping(uint => offer) public offers;
    uint public offersSize;

    error NotEnoughEther();
    error NotThePublisher();
    error NotEnoughStake();
    error CannotReview();

    function registerPublisher(string memory publisherName) public payable
    {
        if (msg.value < 1e15) revert NotEnoughEther();
        address publisher = msg.sender;
        publishersStakes[publisher] += msg.value;
        publishersNames[publisher] = publisherName;
    }

    function unregisterPublisher() public 
    {
        address publisher = msg.sender;
        uint256 publisherStake = publishersStakes[publisher];
        if (publisherStake == 0) revert NotEnoughEther();
        publishersStakes[publisher] = 0;
        payable(msg.sender).transfer(publisherStake);
    }

    function setOffer(string memory metadata, uint256 price, string memory sample, string memory data) public
    {
        if (publishersStakes[msg.sender] < (1e15 * publishersOffers[msg.sender] + 1e15)) revert NotEnoughStake();
        offer storage o = offers[offersSize++];
        publishersOffers[msg.sender]++;
        string[] memory reviews;
        string[] memory dataArray;
        uint[] memory ratings;
        o.publisher = msg.sender;
        o.id = offersSize;
        o.metadata = metadata;
        o.purchasesSize = 0;
        o.reviews = reviews;
        o.ratings = ratings;
        o.rating = 0;
        o.price = price;
        o.sample = sample;
        o.data = data;
        o.dataArray = dataArray;
    }

    function addDataToOffer(uint256 offerId, string memory data) public
    {
        offer storage o = offers[offerId];
        if (msg.sender != o.publisher) revert NotThePublisher();
        o.dataArray.push(data);
    }

    function writeReview(uint256 offerId, string memory review, uint rating) public checkIfCanReview(offerId)
    {
        offer storage o = offers[offerId];
        
        o.reviews.push(review);
        o.ratings.push(rating);
        publishersRating[o.publisher] = (publishersRating[o.publisher] * publishersNumberOfRatings[o.publisher] + rating) / (publishersNumberOfRatings[o.publisher] + 1);
        publishersNumberOfRatings[o.publisher]++;
        if (o.ratings.length == 0)
        {
            o.rating = rating;
        }
        else
        {
            o.rating = (o.rating * o.ratings.length + rating) / (o.ratings.length + 1);
        }

        checkPublisherScore(o.publisher);
    }

    modifier checkIfCanReview(uint256 offerId)
    {
        offer storage o = offers[offerId];
        if (o.canReview[msg.sender] != true) revert CannotReview();
        _;
    }

    function checkPublisherScore(address publisher) internal
    {
        if (publishersRating[publisher] < 20)
        {
            slashPublisher(publisher);
        }
    }

    function slashPublisher(address publisher) internal
    {
        uint256 amountSlashed = publishersStakes[publisher] / 2;
        publishersStakes[publisher] = amountSlashed;
        balance += amountSlashed;
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