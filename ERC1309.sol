pragma solidity ^0.5.0;

import "ERC20Capped.sol";

contract ERC1309 is ERC20Capped, ERC1309VotingToken {

    address[] private _totalAddresses;

    struct Proposal {
        address author;
        string title;
        string description;
        bytes hashed;
        uint256 tokens = 0;
    }

    mapping(bytes => Proposal) private _proposals;

    function _mint(address account, uint256 value) internal {
        require(totalSupply().add(value) <= _cap, "ERC20Capped: cap exceeded");
        totalAddresses.push(account);
        super._mint(account, value);
    }

    function makeProposal(address author, string title, string description) public returns bool {
        require(_balances[author] > 0);
        proposalHash = keccak256(title, author);
        var proposal = _proposals[proposalHash];
        proposal.author = author;
        proposal.title = title;
        proposal.description = description;
        proposal.hash = proposalHash;
        return _createVotingToken(author, proposal);
    }

    function getProposal(bytes proposalHash) public returns Proposal {
        require(_proposals[proposalHash]);
        return _proposals[proposalHash];
    }

    function _createVotingToken(address author, Proposal proposal) private returns bool {
        uint256 tokenCounter = 0;
        for(uint i=0; i < _totalAddresses.length; i++) {
            for(uint x=0; x < _balances[_totalAddresses[i]]; x++) {
                tokenHash = keccak256(tokenCounter, proposal.hashed);
                safeMint(_totalAddresses[i], tokenHash, proposal.hashed);
                tokenCounter++;
            }
        }
        proposal.tokens = tokenCounter;
        return true;
    }

    function getVoterTally(bytes proposalHash) public view returns bool {
        var proposal = _proposals[proposalHash];
        return countVotes(proposal.tokens, proposal.hashed);
    }

}
