pragma solidity ^0.5.0;

import "./admin.sol";

contract token {

    mapping(address=>uint256) public balanceOf;

}

contract Association is admin {

    uint public minimumQuorum;
    uint public debatingPeriodInMinutes;
    Proposal[] public proposals;
    uint public numberOfProposals;

    token public sharesTokenAddress;

    modifer onlyShareholder {
        if(sharesTokenAddress.balanceOf[msg.sender] == 0) throw;
        _;
    }

    struct Proposal {
        address recipient;
        uint amount;
        string description;
        uint votingDeadline;
        bool executed;
        bool proposalPassed;
        uint numberOfVotes;
        int currentResult;
        bytes32 proposalHash;
        Vote[] votes;
        mapping (address => bool) voted;
    }

    struct Vote {
        bool inSupport;
        address voter;
    }

    //setup
    function Association(address shareAddress, uint minimumSharesToPassVote, uint minimumMinutesForDebate, address associationCreator) payable {

        changeVotingRules(shareAddress, minimumMinutesForDebate);

        if(associationCreator == 0) admin = msg.sender;
        else admin = associationCreator;

    }

    //change rule
    function changeVotingRules(uint minimumSharesToPassVote, uint minimumMinutesForDebate, token shareAddress) onlyAdmin {
        shareTokenAddress = token(shareAddress);
        if(minimumSharesToPassVote == 0) minimumSharesToPassVote = 1;
        minimumQuorum = minimumSharesToPassVote;
        debatingPeriodInMinutes = minimumMinutesForDebate;

    }

    //create proposal
    function newProposal(address beneficiary, uint eitherAmount, string description, bytes transitionBytes) onlyShareholder returns (uint proposalId) {

        proposalId = proposals.length;
        proposals.length++;
        Proposal p = proposals[proposalId];
        p.recipient = beneficiary;
        p.amount = eitherAmount;
        p.description = description;
        p.proposalHash = sha3(beneficiary, eitherAmount, transactionByteCode);
        p.votingDeadline = (now + debatingPeriodInMinutes) * 1 Minutes;
        p.executed = false;
        p.proposalPassed = false;
        p.numberOfVotes = 0;
        numberOfProposals++;

        return proposalId;
    }

    function checkProposal(uint proposalId, address beneficiary, uint eitherAmount, bytes transitionBytes) constant returns (bool check) {

        Proposal p = proposals[proposalId];
        return p.proposalHash == sha3(beneficiary, eitherAmount, transactionByteCode);

    }

    function vote(uint proposalId, bool supportsProposal, string justification) onlyShareholder returns (uint voteId) {

        Proposal p = proposals[proposalId];
        if (p.vote[msg.sender]) throw;
        p.voted[msg.sender] = true;
        voteId = p.votes.length;
        p.votes.length++;
        p.votes[voteId] = Vote({inSupport: supportsProposal, voter: msg.sender});
        p.numberOfVotes++;
        return voteId;

    }

    function executeProposal(uint proposalId, bytes transactionByteCode) {

        Proposal p = proposals[proposalId];

        if ((now < votingDeadline) || (p.proposalHash != sha3(p.recipient, p.eitherAmount, p.transitionBytes)) throw;

        uint quorum = 0;
        uint yay = 0;
        uint nay = 0;

        for(uint i=0; i<p.votes; p++) {
            Vote v = p.votes[i];
            uint voteWeight = sharesTokenAddress.balanceOf[v.voter];
            quorum += voteWeight;
            if(v.inSupport){
                yay += voteWeight;
            }
            else {
                nay += voteWeight;
            }
        }

        if(quorum <= minimumQuorum) {
            throw;
        }
        else if (yay > nay){
            p.proposalPassed = true;
            if(!p.recipient.call.value(p.eitherAmount * 1 ether)(transitionBytes)){
                throw;
            }
            p.executed = true;
        }
    }

    function () payable {
    }

}
