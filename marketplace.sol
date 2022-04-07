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
    
    mapping(address => uint256) public publishersStakes;
    mapping(address => uint256) publishersOffers;
    mapping(address => uint256) public publishersRating;
    mapping(address => uint256) publishersNumberOfRatings;
    mapping(address => string) public publishersNames;
    

    struct purchase
    {
        address buyer;
        uint timestamp;
        string key;
        uint deposit;
    }

    struct offer 
    {
        address publisher;
        string metadata;
        mapping(uint => purchase) purchases;
        uint purchasesSize;
        mapping(address => uint) purchaseAddress;
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
        o.canReview[msg.sender] = false;
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

    function depositPayment(uint256 offerId) public payable
    {
        offer storage o = offers[offerId];
        if (msg.value < o.price) revert NotEnoughEther();
        purchase storage p = o.purchases[o.purchasesSize++];
        p.buyer = msg.sender;
        p.timestamp = block.timestamp;
        p.deposit = msg.value;
        o.purchaseAddress[msg.sender] = o.purchasesSize - 1;
        o.canReview[msg.sender] = true;
    }

    function sendKey(uint256 offerId, address buyer, string memory key) public
    {
        offer storage o = offers[offerId];
        if (msg.sender != o.publisher) revert NotThePublisher();
        uint256 purchaseId = o.purchaseAddress[buyer];
        purchase storage p = o.purchases[purchaseId];
        p.key = key;
        p.deposit = 0;
        uint deposit = p.deposit;
        payable(msg.sender).transfer(deposit);
    }

    function readKey(uint256 offerId) public view returns(string memory)
    {
        offer storage o = offers[offerId];
        uint256 purchaseId = o.purchaseAddress[msg.sender];
        purchase storage p = o.purchases[purchaseId];
        return p.key;
    }

}