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

        

    }

    function removeMember(address targetMember) onlyAdmin {

    }

    //change rule
    function changeVotingRules(uint minimumQuorumForProposal, uint minimumMinutesForDebate, int maginOfVotes) onlyAdmin {

        minimumQuorum = minimumQuorumForProposal;
        debatingPeriodInMinutes = minimumMinutesForDebate;
        majorityMargin = marginOfVotes;

    }

    //create proposal
    function newProposal() {

    }
}
