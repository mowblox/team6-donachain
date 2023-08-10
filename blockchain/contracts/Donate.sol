// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Donate {
    // This is the get
    event DonationSent(
        address indexed sender_address,
        address indexed reciever_address,
        uint amount
    );

    struct Donor {
        string name;
        string phone;
        address sAddr;
    }

    struct Organisation {
        string name;
        string phone;
        address rAddr;
    }

    mapping(address => Donor) RegisteredDonors;

    mapping(address => Organisation) RegisteredOrganisations;

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
    function checkBalance() public {}

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

        payable(msg.sender).transfer(amount);

        emit DonationSent(sender_address, reciever_address, amount);
    }

    // Authenticate user
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
}
