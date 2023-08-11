// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Donate {
    // This is the get
    event DonationSent(
        address indexed sender_address,
        address indexed reciever_address,
        uint amount
    );

    event FundWithdraw(address indexed wallete, uint amount);

    struct Donor {
        string name;
        string phone;
        address sAddr;
    }

    struct Organisation {
        string name;
        string phone;
        uint balance;
        address rAddr;
    }

    mapping(address => Donor) RegisteredDonors;

    mapping(address => Organisation) RegisteredOrganisations;

    uint totalBalances; // track balance for everyone

    // Get project details {organization id , organization address , project id }
    function getRegisteredDonor(
        address addr
    ) public view returns (Donor memory) {
        return RegisteredDonors[addr];
    }

    // Get project details {organization id , organization address , project id }
    function getRegisteredOrganisation(
        address addr
    ) public view returns (Organisation memory) {
        return RegisteredOrganisations[addr];
    }

    // Check if donor address has sufficient amount of money
    function checkBalance(address wallet) public {}

    function checkOrgBalance(address orgAddr) public view returns (uint) {
        return RegisteredOrganisations[orgAddr].balance;
    }

    // Transfer donation
    function sendDonation(address reciever_address) public payable {
        //Debit Transation has a variable called msg that has methods
        address sender_address = msg.sender;
        uint amount = msg.value;

        if (RegisteredDonors[sender_address].sAddr != sender_address) {
            revert("You donot have an account!");
        }

        if (
            RegisteredOrganisations[reciever_address].rAddr != reciever_address
        ) {
            revert("Organisation Does not exist!");
        }

        // TODO: Refactor to send the token to the contract instead of sending it to the organisation directly

        // payable(msg.sender).transfer(amount);
        // bool sent = payable(sender_address).send(msg.value);
        totalBalances += amount;
        RegisteredOrganisations[reciever_address].balance += amount;

        emit DonationSent(sender_address, reciever_address, amount);
    }

    // Authenticate user and add users
    function AddOrganisation(string memory name, string memory phone) public {
        address reciever_address = msg.sender;
        RegisteredOrganisations[reciever_address].name = name;
        RegisteredOrganisations[reciever_address].phone = phone;
        RegisteredOrganisations[reciever_address].rAddr = reciever_address;
    }

    function AddDonor(string memory name, string memory phone) public {
        address sender_address = msg.sender;
        RegisteredDonors[sender_address].name = name;
        RegisteredDonors[sender_address].phone = phone;
        RegisteredDonors[sender_address].sAddr = sender_address;
    }

    // TODO: Implement the withdrawal function to withdraw the funds from the contract so as to be able to track donations
    function OrgWithdraw() external payable {
        address addr = msg.sender;

        require(
            RegisteredOrganisations[addr].rAddr == addr,
            "Address Not Found, Must register to be able to withdraw."
        );

        uint amount = checkOrgBalance(addr);
        RegisteredOrganisations[addr].balance = 0;

        payable(addr).transfer(amount);
        emit FundWithdraw(addr, amount);
    }
}
