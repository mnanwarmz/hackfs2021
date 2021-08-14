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

	// This should be protected with owner only but for demonstration purposes, it is removed.
	function setOwner(address _newOwner) public {
		owner = _newOwner;
	}

	// Defining Struct for Token
	struct ProductToken {
		bool tokenExist;
		uint tokenAmount;
	}

	// Mapping of users' addresses against tokens, and
	// Mapping of Products to number of tokens
	mapping (address => mapping (uint=>ProductToken)) user_tokens;

	// Mapping from productId to userAddress and IPFS hash
	mapping (uint => mapping (address => string[])) user_reviews;

	// User exist mapping
	mapping (address => bool) userExist;
	// List of users
	address[] public users;

	// Product exist mapping
	mapping (uint => bool) productExist;

	// List of products
	uint[] public products;

	// Display user tokens
	function displayTokens(address _userAdd, uint _productId) public view returns (uint) {
		return (user_tokens[_userAdd][_productId].tokenAmount);
	}

	function updateLists(address _userAdd, uint _productId) private {
		if (userExist[_userAdd] == false) {
			users.push(_userAdd);
			userExist[_userAdd] = true;
		}
		if (productExist[_productId] == false) {
			products.push(_productId);
			productExist[_productId] = true;
		}
	}

	// Owner functions
	function giveToken(address _userAdd, uint _productId) public {
		updateLists(_userAdd, _productId);
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
	function writeReview(uint _productId, string memory _reviewHash) public hasToken(_productId) {
		user_reviews[_productId][msg.sender].push(_reviewHash);
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

	// Check existance of product
	modifier productInStore(uint _productId) {
		require(productExist[_productId] == true, "PRODUCT DOES NOT EXIST");
		_;
	}

	function noOfReviewsProduct(uint _productId) private view returns (uint) {
		uint totalReviews = 0;
		for (uint i = 0; i < users.length; i++) {
			address userAdd = users[i];
			string[] memory userReviews = user_reviews[_productId][userAdd];
			for (uint j = 0; j < userReviews.length; j++) {
				totalReviews += 1;
			}
		}
		return (totalReviews);
	}

	// loops through mapping with users length and number of reviews
	function displayMultipleReviewsProduct(uint _productId) public view productInStore(_productId) returns (string[] memory) {
		uint reviewNum = noOfReviewsProduct(_productId);
		string[] memory reviewHashes = new string[](reviewNum);
		uint index = 0;
		for (uint i = 0; i < users.length; i++) {
			address userAdd = users[i];
			string[] memory userReviews = user_reviews[_productId][userAdd];
			for (uint j = 0; j < userReviews.length; j++) {
				reviewHashes[index] = user_reviews[_productId][userAdd][j];
				index += 1;
			}
		}
		return (reviewHashes);
	}

	// Check existance of product
	modifier userInStore(address _userId) {
		require(userExist[_userId] == true, "USER DOES NOT EXIST");
		_;
	}

	function noOfReviewsUser(address _userId) private view returns (uint) {
		uint totalReviews = 0;
		for (uint i = 0; i < products.length; i++) {
			uint productId = products[i];
			string[] memory userReviews = user_reviews[productId][_userId];
			for (uint j = 0; j < userReviews.length; j++) {
				totalReviews += 1;
			}
		}
		return (totalReviews);
	}

	// loops through mapping with users length and number of reviews
	function displayMultipleReviewsUser(address _userId) public view userInStore(_userId) returns (string[] memory) {
		uint reviewNum = noOfReviewsUser(_userId);
		string[] memory reviewHashes = new string[](reviewNum);
		uint index = 0;
		for (uint i = 0; i < products.length; i++) {
			uint productId = products[i];
			string[] memory userReviews = user_reviews[productId][_userId];
			for (uint j = 0; j < userReviews.length; j++) {
				reviewHashes[index] = user_reviews[productId][_userId][j];
				index += 1;
			}
		}
		return (reviewHashes);
	}

	constructor() {
		// what should we do on deploy?
	}
}
