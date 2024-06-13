// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

contract aryanCharityPlatform {
    address public owner;
    uint public count;
    struct Campaign {
        address owner;
        string name;
        string description;
        uint goal;
        uint total;
        bool isActive;
        bool isCompleted;}

    mapping(uint => Campaign) public campaigns;
    mapping(uint => mapping(address => uint)) public donations;

    event created(uint indexed id, address indexed campaignOwner, string name, uint goal);
    event recieved(uint indexed id, address indexed donor, uint amount);
    event refunde(uint indexed id, address indexed donor, uint amount);
    event completed(uint indexed id);
    event paused(uint indexed id);
    event resumee(uint indexed id);
    event Updated(uint indexed id, string newName, string newDescription, uint newgoal);
    event OwnershipTransferred(uint indexed id, address indexed previousOwner, address indexed newOwner);

    constructor() {
        owner = msg.sender;}

    function create(string memory _name,string memory _Description,uint _goal) external {
        require(_goal > 0, "Goal amount must be greater than zero");
        count++;
        campaigns[count] = Campaign({
            owner: msg.sender,
            name: _name,
            description: _Description,
            goal: _goal,
            total: 0,
            isActive: true,
            isCompleted: false
        });
        emit created(count, msg.sender, _name, _goal);}

    function donate(uint _id) external payable {
        Campaign storage campaign = campaigns[_id];
        require(campaign.isActive, "Campaign is not active");
        require(msg.value > 0, "Donation amount must be greater than zero");
        require(campaign.total < campaign.goal, "Goal amount already reached");
        campaign.total += msg.value;
        donations[_id][msg.sender] += msg.value;
        emit recieved(_id, msg.sender, msg.value);
        if (campaign.total >= campaign.goal) {
            campaign.isActive = false;
            campaign.isCompleted = true;
            emit completed(_id);}}

    function refund(uint _id) external {
        Campaign storage campaign = campaigns[_id];
        uint donationAmount = donations[_id][msg.sender];
        require(campaign.isActive, "Campaign is not active");
        require(donationAmount > 0, "No donations to refund");
        campaign.total -= donationAmount;
        donations[_id][msg.sender] = 0;
        payable(msg.sender).transfer(donationAmount);
        emit refunde(_id, msg.sender, donationAmount);
        assert(campaign.total >= 0);}

    function withdraw(uint _id) external {
        Campaign storage campaign = campaigns[_id];
        require(msg.sender == campaign.owner, "Only the owner can withdraw funds");
        require(!campaign.isActive, "Campaign is still active");
        uint balance = address(this).balance;
        assert(balance > 0); 
        payable(campaign.owner).transfer(balance);}

    function pause(uint _id) external {
        Campaign storage campaign = campaigns[_id];
        require(msg.sender == campaign.owner, "Only the owner can pause the campaign");
        require(campaign.isActive, "Campaign is already inactive");
        campaign.isActive = false;
        emit paused(_id);}

    function resume(uint _id) external {
        Campaign storage campaign = campaigns[_id];
        require(msg.sender == campaign.owner, "Only the owner can resume the campaign");
        require(!campaign.isActive && !campaign.isCompleted, "Campaign is already active or completed");
        campaign.isActive = true;
        emit resumee(_id);}

    function update(uint _id, string memory _newName, string memory _newDescription, uint _newgoal) external {
        Campaign storage campaign = campaigns[_id];
        require(msg.sender == campaign.owner, "Only the owner can update the campaign");
        require(campaign.isActive, "Campaign is not active");
        require(_newgoal >= campaign.total, "New goal amount must be greater than or equal to total donations");
        campaign.name = _newName;
        campaign.description = _newDescription;
        campaign.goal = _newgoal;
        emit Updated(_id, _newName, _newDescription, _newgoal);}

    function transferOwnership(uint _id, address _newOwner) external {
        Campaign storage campaign = campaigns[_id];
        require(msg.sender == campaign.owner, "Only the owner can transfer ownership");
        require(_newOwner != address(0), "Invalid address");
        address previousOwner = campaign.owner;
        campaign.owner = _newOwner;
        emit OwnershipTransferred(_id, previousOwner, _newOwner);}


    function getcount() external view returns (uint) {
        return count;}

    receive() external payable {
        revert("Direct donations not allowed. Use the donate function.");}
}
