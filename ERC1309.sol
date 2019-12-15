pragma solidity ^0.5.0;

import "ERC20Capped.sol";

contract ERC1309 is ERC20Capped {

    address[] public totalAddresses;

    function _mint(address account, uint256 value) internal {
        require(totalSupply().add(value) <= _cap, "ERC20Capped: cap exceeded");
        super._mint(account, value);
        totalAddresses.push(account);
    }

}
