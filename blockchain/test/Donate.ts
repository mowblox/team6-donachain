import {
    time,
    loadFixture,
  } from "@nomicfoundation/hardhat-toolbox/network-helpers";
  import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
  import { expect } from "chai";
  import { ethers } from "hardhat";

describe('Donor', function () {
    async function deployDonationFixture() {
        // Contracts are deployed using the first signer/account by default
        const [owner, org1, sender1, org2, send3, org3] = await ethers.getSigners();

        const Donate = await ethers.getContractFactory("Donate");
        const donate = await Donate.deploy();

        return { donate, owner, org1, sender1, org2, send3, org3 };
    }

    describe("Create Organisation", function (){
        it("Organisation must exist", async function(){
            const name = "John Smith";
            const phone = "555-555";
            const {donate, org1} = await loadFixture(deployDonationFixture);

           await donate.connect(org1).AddOrganisation(name, phone);

           const orgData = await donate.connect(org1).getRegisteredOrganisation(org1);

        //    console.log(orgData);

           expect(orgData[2]).to.equal(org1.address);
        })

        it ("Check Send Donation", async function(){
            const {donate, org1, sender1} = await loadFixture(deployDonationFixture);
            const amount  = ethers.parseEther("100")
            const name = "John Smith";
            const phone = "555-555";
           await donate.connect(org1).AddOrganisation(name, phone);
           await donate.connect(sender1).AddDonor(name, phone);

            expect(await donate.connect(sender1).sendDonation(org1, {value: amount}))
          .to.emit(donate, "DonationSent")
          .withArgs(sender1, org1, amount); 

        })

        // it("Check list of Donation from Donors", async function(){
        //     const addr;
        // })


    })

    
});