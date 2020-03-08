import "./admin.sol";

contract Congress is admin {

    uint public minimumQuorum;
    uint public debatingPeriodInMinutes;
    int public majorityMargin;
    Proposal[] public proposals;
    uint public numberOfProposals;
    mapping (address => uint) public memberId;
    Member[] public members;

    modifer onlyMember {
        if(memberId[msg.sender] == 0) throw;
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
        string name;
        uint memberSince;
    }

    struct Member {
        address member;
        string name;
        uint memberSince;
    }

    //setup
    function Congress(uint minimumQuorumForProposal, uint minimumMinutesForDebate, int maginOfVotes, address congressCreator) payable {

        changeVotingRules(minimumQuorumForProposal, minimumMinutesForDebate, marginOfVotes);

        if(congressCreator == 0) admin = msg.sender;
        else admin = congressCreator;

        addMember(0,"");
        addMember(admin,"Admin")

    }

    //add member
    function addMember(address targetMember, string memberName) onlyAdmin {

        uint id;
        if(memberId[targetMember] == 0) {
            id = members.length;
            members.length++;
            memberId[targetMember] = id;
            members[id] = Member({member: targetMember, memberSince: now, name = memberName});
        } else {
            id = memberId[targetMember];
            Member m = members[id];
        }

    }

    function removeMember(address targetMember) onlyAdmin {
        if(memberId[targetMember] ==) throw;
        // for (uint i = memberId[targetMember]; i < members.length -1; i++) {
        //     member[i] = members[i+1];
        // }
        // delete members[members.length-1];
        delete members[targetMember];
        members.length--;
    }

    //change rule
    function changeVotingRules(uint minimumQuorumForProposal, uint minimumMinutesForDebate, int maginOfVotes) onlyAdmin {

        minimumQuorum = minimumQuorumForProposal;
        debatingPeriodInMinutes = minimumMinutesForDebate;
        majorityMargin = marginOfVotes;

    }

    //create proposal
    function newProposal(address beneficiary, uint eitherAmount, string description, bytes transitionBytes) onlyMember returns (uint proposalId) {

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

    function vote(uint proposalId, bool supportsProposal, string justification) onlyMember returns (uint voteId) {

        Proposal p = proposals[proposalId];
        if (p.vote[msg.sender]) throw;
        p.voted[msg.sender] = true;
        p.numberOfVotes++;
        if(supportsProposal){
            p.currentResult++;
        }
        else {
            p.currentResult--;
        }

        return p.numberOfVotes-1;

    }

    function executeProposal(uint proposalId, bytes transactionByteCode) {

        Proposal p = proposals[proposalId];

        if ((now < votingDeadline) || (p.proposalHash != sha3(p.recipient, p.eitherAmount, p.transitionBytes) || p.numberOfVotes < minimumQuorum) throw;

        if(p.currentResult = majorityMargin) {
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
