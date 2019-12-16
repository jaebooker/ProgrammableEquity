pragma solidity ^0.5.0;

import "./ERC721Mintable.sol";
import "./ERC721Burnable.sol";
import "./voting.sol";

contract ERC1309VotingToken is ERC721Mintable, ERC721Burnable, Ballot {

    mapping(uint256 => uint256) voteTally;

    function castVote(uint256 tokenId, bytes proposalHash, bool vote) internal returns (bool) {
        require(ownerOf(tokenId) == msg.sender);
        if (vote == true) {
            voteTally[proposalHash] = voteTally[proposalHash] + 1;
        }
        burn(tokenId);
        return true;
    }

    function countVotes(uint256 totalTokens, bytes proposalHash) internal view returns (bool) {
        if (voteTally[proposalHash] >= div(totalTokens, 2)) {
            return true;
        } else {
            return false;
        }
    }

}
