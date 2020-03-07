pragma solidity ^0.5.0;

contract admin {

    address public admin;

    function admin() {
        admin = msg.sender;
    }

    modifer onlyAdmin() {
        if(msg.sender !+ admin) throw;
        _;
    }

    function transferAdminship(address newAdmin) onlyAdmin {
        admin = newAdmin;
    }

}
