# Eth-AVAX-project
This is a Solidity application where I implement the error-handling methods of Solidity. This program will provide the use case for all three error handling methods 
**require(), assert() and revert()** . The fundamental ideas of a Solidity, such as function and if condition, are used in this code.

# Description
This Solidity code generates the aryanCharityPlatform smart contract, which shows how to use the require(), assert(), and revert() instructions to manage issues in campaign creation, donations, refunds, and withdrawals. The contract has many events to track different processes, including generated, received, refunded, finished, halted, resumed, updated, and ownership transferred. It also includes mappings to track donations and campaigns.
The create() function allows users to create campaigns. The require() statement is used to make sure the desired amount is greater than 0. The transaction is reversed and the message "Goal amount must be greater than zero" appears if this requirement is not satisfied. The campaign is subsequently added to the list of campaigns and an event is produced and sent.
The donate() function allows users to contribute to a campaign. Require() statements are used to confirm that the campaign is active, the donation amount is more than 0, and the campaign has not yet accomplished its objective. If these conditions are not met, the transaction is reversed along with the pertinent error messages. The donor's charity is noted, the amount donated is added to the campaign's total, and a received event is created. An assert() statement guarantees logical coherence, a finished event is emitted, and the campaign is considered as completed if its total meets or surpasses the objective.

The refundDonation() function allows users to obtain a refund for their contributions. The require() statements determine if the user has donations to return and whether the campaign is live. If these requirements are not satisfied, the transaction is reversed along with the pertinent error messages. A refund event is emitted, the donated amount is subtracted from the campaign's total, and the user receives their money back. The campaign's total is guaranteed not to be negative by an assert() statement.
Funds can be withdrawn by campaign owners by utilising the withdraw() function. The require() statements guarantee that the campaign is not running and that only the campaign owner may withdraw money. Before sending the money to the campaign owner, an assert() function verifies the amount of the contract.

The pauseCampaign() and resumeCampaign() functions allow campaign owners to pause and resume their campaigns, accordingly. Before making any modifications, require() statements confirm the ownership and current condition of the campaign. Emitted are corresponding events that pause and resume.
The update() function allows campaign owners to update their campaign's information. Require() statements make sure the campaign is active, the user is the owner, and the new objective is at least equal to the entire amount of donations received. An revised event is issued along with the revised campaign data.
The transferOwnership() function may be used to change the ownership of a campaign. require() expressions Before transferring ownership, confirm the new owner's address and check who is currently the owner. There is an emitted OwnershipTransferred event.


# Getting Start
To start working with this programming language, you need first run the Remix online IDE, which is the solidity compiler, at https://remix.ethereum.org/ . Now, when the IDE launches, you have to create a file in which to write code. Click the new file option that shows up in the sidebar on the left to accomplish this. Choose a name for the file and save it with the .sol extension. Use aryan-charityPlatform.sol as an example.
```
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
    event refund(uint indexed id, address indexed donor, uint amount);
    event completed(uint indexed id);
    event paused(uint indexed id);
    event resume(uint indexed id);
    event Updated(uint indexed id, string newName, string newDescription, uint newgoal);
    event OwnershipTransferred(uint indexed id, address indexed previousOwner, address indexed newOwner);

    constructor() {
        owner = msg.sender;}

    function createCampaign(string memory _name, string memory _Description, uint _goal) external {
        require(_goal > 0, "Goal amount must be greater than zero");
        count++;
        campaigns[count] = Campaign({
            owner: msg.sender,
            name: _name,
            description: _Description,
            goal: _goal,
            total: 0,
            isActive: true,
            isCompleted: false});
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

    function refundDonation(uint _id) external {
        Campaign storage campaign = campaigns[_id];
        uint donationAmount = donations[_id][msg.sender];
        require(campaign.isActive, "Campaign is not active");
        require(donationAmount > 0, "No donations to refund");
        campaign.total -= donationAmount;
        donations[_id][msg.sender] = 0;
        payable(msg.sender).transfer(donationAmount);
        emit refund(_id, msg.sender, donationAmount);
        assert(campaign.total >= 0);}

    function withdraw(uint _id) external {
        Campaign storage campaign = campaigns[_id];
        require(msg.sender == campaign.owner, "Only the owner can withdraw funds");
        require(!campaign.isActive, "Campaign is still active");
        uint balance = address(this).balance;
        assert(balance > 0);
        payable(campaign.owner).transfer(balance);}

    function pauseCampaign(uint _id) external {
        Campaign storage campaign = campaigns[_id];
        require(msg.sender == campaign.owner, "Only the owner can pause the campaign");
        require(campaign.isActive, "Campaign is already inactive");
        campaign.isActive = false;
        emit paused(_id);}

    function resumeCampaign(uint _id) external {
        Campaign storage campaign = campaigns[_id];
        require(msg.sender == campaign.owner, "Only the owner can resume the campaign");
        require(!campaign.isActive && !campaign.isCompleted, "Campaign is already active or completed");
        campaign.isActive = true;
        emit resume(_id);}

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

```

Choose the "Solidity Compiler" tab from the sidebar on the left to begin the code compilation process. Click "Compile aryan-charityPlatform.sol" only after making sure the "Compiler" option is set to "0.8.18". Once the code has been compiled, click the relevant button to deploy the contract.

When the contract launches, you will notice orange buttons that correspond to its many functions. To try the different functions, such starting a campaign, making donations, getting your money back, and taking money out, click the orange buttons and enter the correct quantities. You may use the require(), assert(), and revert() commands to see how the contract handles problems and maintains logical consistency.

# Explanation
My initial action was to draft the contract for the aryanCharityPlatform. I created many events to track transactions and established mappings to keep an eye on donations and campaigns. In the createCampaign method, I used the require() expression to make sure the objective amount is more than 0. The transaction is reversed and the error notice "Goal amount must be greater than zero" displays if the criteria is not satisfied. After that, the campaign is added to the list of campaigns and the generated event is sent.

To make sure the campaign is active, the donation amount is more than 0, and the campaign's total has not yet hit its goal, I used require() statements in the contribute method. If these conditions are not met, the transaction is reversed along with the pertinent error messages. The donor's gift is noted, the amount donated is added to the campaign's total, and a received event is created. An assert() statement verifies logical coherence before emitting the finished event, and the campaign is recognised as completed if its total approaches or above the objective.

To make sure the campaign is running and the user has donations to return, I used require() statements in the refundDonation function. If these requirements are not satisfied, the transaction is reversed along with the pertinent error messages. A refund event is emitted, the donation amount is subtracted from the campaign's total, and the user receives their money back. The campaign's total is guaranteed not to be negative by an assert() statement.

To make sure the campaign is inactive and that only the campaign owner may take cash, I used require() statements in the withdraw function. Before sending the money to the campaign owner, an assert() function verifies the amount of the contract.

Before making any modifications, I used require() statements in the pauseCampaign and resumeCampaign methods to confirm the campaign's ownership and current status. Emitted are corresponding events that pause and resume.

To make sure the user is the campaign owner, the campaign is active, and the new goal is at least as much as the total donations received, I used require() statements in the update function. An revised event is issued along with the revised campaign data.

Finally, before transferring ownership, I verified the new owner's address and checked the ownership status using require() statements in the transferOwnership function. There is an emitted OwnershipTransferred event. This contract demonstrates the use of the require(), assert(), and revert() commands to manage failures in Solidity.
# License
This project is licensed under the MIT License - see the LICENSE.md file for details


