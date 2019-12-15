pragma solidity ^0.5.0;

import "ERC20Capped.sol";

contract ERC1309 is ERC20Capped, ERC1309VotingToken {

    address[] private _totalAddresses;

    struct Proposal {
        address author;
        string title;
        string description;
    }

    mapping(address => Proposal) private _proposals;

    function _mint(address account, uint256 value) internal {
        require(totalSupply().add(value) <= _cap, "ERC20Capped: cap exceeded");
        super._mint(account, value);
        totalAddresses.push(account);
    }

    function makeProposal(address author, string title, string description) {
        require(_balances[author] > 0);
        var proposal = _proposals[author];
        proposal.author = author;
        proposal.title = title;
        proposal.description = description;
    }

}
