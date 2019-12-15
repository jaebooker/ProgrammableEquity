pragma solidity ^0.5.0;

import "ERC721Mintable.sol";
import "ERC721Burnable.sol";
import "voting.sol";

contract ERC1309VotingToken is ERC721Mintable, ERC721Burnable, Ballot {

    function castVote(uint256 tokenId) public returns bool {
        require(ownerOf(uint256 tokenId) == msg.sender);

    }

}
