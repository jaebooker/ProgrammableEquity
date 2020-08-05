#Creating a distributed protocol for handling equity

Bitcoin brought about a change in how we perceive money.

Ethereum changed how we perceive what an application can be.

Now we're changing how we perceive a fundamental element of commerce: ownership of a company.

#Contracts

ERC1309 - Handles token ownership and voting protocol. Creates a non-tradable ERC721 voting token to allow users to vote on company decisions. This uses a different token so that all ERC1309s can have equal trading value. Without this, ERC1309s that haven't voted on certain proposals would be worth more than those that have, hurting fungibility. 

#DAO

DAO - Handles all the properties of a normal DAO. DAOToken handles all the normal properties of a DAO, but also can be integrated with the ERC1309 Token Standard to provide participants with voting proportional to their equity ownership.

All contracts are implemented with OpenZeppelin's standards of security.
