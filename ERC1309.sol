pragma solidity ^0.5.0;

import "ERC20Capped.sol";

contract ERC1309 is ERC20Capped, ERC1309VotingToken {

    address[] private _totalAddresses;

    struct Proposal {
        address author;
        string title;
        string description;
        bytes hashed;
    }

    mapping(address => Proposal) private _proposals;

    function _mint(address account, uint256 value) internal {
        require(totalSupply().add(value) <= _cap, "ERC20Capped: cap exceeded");
        super._mint(account, value);
        totalAddresses.push(account);
    }

    function makeProposal(address author, string title, string description) public returns bool {
        require(_balances[author] > 0);
        //TODO: hash proposal
        var proposal = _proposals[proposalHash];
        proposal.author = author;
        proposal.title = title;
        proposal.description = description;
        //proposal.hash = hashed proposal title
        return _createVotingToken(author, proposal);
    }

    function getProposal(bytes proposalHash) public returns Proposal {
        require(_proposals[proposalHash]);
        return _proposals[proposalHash];
    }

    function _createVotingToken(address author, proposal Proposal) private returns bool {
        uint tokenCounter = 0;
        for(uint i=0; i < _totalAddresses.length; i++) {
            for(uint x=0; x < _balances[_totalAddresses[i]]; x++) {
                var tokenHash = proposal.hashed + tokenCounter
                safeMint(address _totalAddresses[i], uint256 tokenHash, bytes memory proposal.hashed);
                tokenCounter++;
            }
        }
        return true;
    }

}
