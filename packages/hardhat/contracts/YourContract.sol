pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
//import "@openzeppelin/contracts/access/Ownable.sol"; //https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol

contract YourContract {

	// Owner functions
	address public owner = 0xb31DCe4e71C8e8d6bC48bB773e342a07c2CBE4f3;

	modifier onlyOwner() {
		require(msg.sender == owner, "NOT THE OWNER");
		_;
	}

	// Defining Structs for Token
	struct ProductToken {
		bool tokenExist;
		uint tokenAmount;
	}

	// Mapping of users' addresses against tokens, and
	// Mapping of Products to number of tokens
	mapping (address => mapping (uint=>ProductToken)) user_tokens;

	// Mapping from productId to userAddress and IPFS hash
	mapping (uint => mapping (address => string[])) user_reviews;

	// Display user tokens
	function displayTokens(address _userAdd, uint _productId) public view returns (uint) {
		return (user_tokens[_userAdd][_productId].tokenAmount);
	}

	// Owner functions
	function giveToken(address _userAdd, uint _productId) public onlyOwner {
		if (user_tokens[_userAdd][_productId].tokenAmount == 0) {
			user_tokens[_userAdd][_productId].tokenAmount = 1;
		}
		else {
			user_tokens[_userAdd][_productId].tokenAmount += 1;
		}
	}

	// User tokens to post reviews
	modifier hasToken(uint _productId) {
		require(user_tokens[msg.sender][_productId].tokenAmount > 0, "INSUFFICIENT FUNDS");
		_;
	}

	// Verifies if user has tokens and subsequently stores reviewHash and deducts userToken amount
	function writeReview(uint _productId, string memory reviewHash) public hasToken(_productId) {
		user_reviews[_productId][msg.sender].push(reviewHash);
		user_tokens[msg.sender][_productId].tokenAmount -= 1;
	}

	// Display review
	function displayReview(address _userAdd, uint _productId, uint reviewIndex) public view returns (string memory) {
		// checking NUL string, convert to byte and subsequently checking byte length > 0
		if (reviewIndex < user_reviews[_productId][_userAdd].length) {
			return (user_reviews[_productId][_userAdd][reviewIndex]);
		}
		return "REVIEW NOT FOUND";
	}

	string public purpose = "Hello world!";
	function setPurpose(string memory _purpose) public {
		purpose = _purpose;
	}
	constructor() {
		// what should we do on deploy?
	}
}
