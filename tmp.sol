pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
//import "@openzeppelin/contracts/access/Ownable.sol"; //https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol

// contract YourContract {

//   //event SetPurpose(address sender, string purpose);

//   string public purpose = "Building UnStoppable Apps";

//   constructor() {
//     // what should we do on deploy?
//   }

//   uint public counter = 1;

//   function setCounter(uint count) public {
//     counter += count;
//   }

//   function returnOne() public pure returns(uint) {
//     return 1;
//   }

//   uint public number = 0;

//   function showOne() public {
//     number = returnOne();
//   }

//   function setPurpose(string memory newPurpose) public {
//       purpose = newPurpose;
//       console.log(msg.sender,"set purpose to",purpose);
//       //emit SetPurpose(msg.sender, purpose);
//   }
// }

contract YourContract {

  struct Status {
        
        bool isPurchased;
        bool doneReview;
        //string reviewDescription;
        uint timeStamp;
    }
  
  struct Product {
        uint id;
        string name;
        string description;
        uint priceWei;
        uint quantity;
        //address payable productOwner;
        //bool isExist;
        address rater; //address of reviewer
        string [] reviews;
        uint reviewsCount;
        mapping (address=>Status) productUserReview; //store the status of buyer
    }

  mapping (uint=>Product) products;

  event SetReview(address sender, string productReview);

  /*event Transfer(
    address indexed _from,
    address indexed _to,
    uint256 _value
  );*/

  address public owner = 0x2E5b16A8e459311884C3f75Ac55012b81bC7d6Bc;

  //string public productReview = "Product Reviews";
  //mapping(address => uint256) public balanceOf;
  mapping(address => uint8) public tokenCount;

  //uint8 public stockCount;
  uint[] productIds;

  modifier onlyOwner() {
        require(msg.sender == owner, "NOT THE OWNER");
        _;
    }

  constructor() {
    // what should we do on deploy?
    uint8 _initialSupply = 100;
    tokenCount[owner] = _initialSupply;
    //uint8 _initialStockCount = 0;
    //stockCount = _initialStockCount;
  }

  /*function ReStock(uint8 _stockQuantity) public payable onlyOwner{
    require(msg.value >= (0.00001 ether * _stockQuantity), "NOT ENOUGH");
    require(_stockQuantity > 0, "PLEASE SELECT AMOUNT");
    require(tokenCount[owner] >= _stockQuantity + stockCount, "PLEASE RELOAD TOKEN");
    stockCount += _stockQuantity;
  }*/

  function owner_AddProduct(uint skuId, string memory name, string memory description, uint priceWei, uint quantity) public onlyOwner
    {
        require(quantity > 0, "PLEASE ENTER QUANTITY");
        require(tokenCount[owner] >= quantity + products[skuId].quantity, "PLEASE RELOAD TOKEN");
        //require(products[skuId].isExist == false, "Product Already Added");
        //productCount+=1;
        products[skuId].id = skuId;
        products[skuId].name = name;
        products[skuId].description = description;
        products[skuId].priceWei = priceWei;
        products[skuId].quantity += quantity;
        //products[skuId].productOwner = msg.sender;
        //products[skuId].isExist = true;
        productIds.push(skuId);
        
    }

  function owner_TokenReload(uint8 _tokenQuantity) public payable onlyOwner{
    require(msg.value >= (0.00001 ether * _tokenQuantity), "NOT ENOUGH");
    tokenCount[owner] += _tokenQuantity;
  }

  function owner_TokenDestroy(uint8 _tokenQuantity) public onlyOwner{
    tokenCount[owner] -= _tokenQuantity;
  }

  function purchaseProduct(uint8 _productQuantity, uint skuId) public payable{
    require(products[skuId].quantity > 0, "OUT OF STOCK");
    require(products[skuId].quantity > _productQuantity, "DON'T HAVE THAT MANY STOCK");
    require(msg.value == (products[skuId].priceWei * _productQuantity), "WRONG AMOUNT");
    require(_productQuantity > 0, "PLEASE SELECT AMOUNT");
    require(msg.sender != owner, "NOT A BUYER");
    //stockCount -= _productQuantity;
    products[skuId].quantity -= _productQuantity;
    if (tokenCount[msg.sender] == 0) {
      tokenCount[msg.sender]++;
      tokenCount[owner]--;
    }
    products[skuId].productUserReview[msg.sender].isPurchased = true;
    products[skuId].productUserReview[msg.sender].doneReview = false;
  }

  /*function transfer(address _to, uint256 _value) public returns (bool success) {
        //require(balanceOf[msg.sender] >= _value);
        require(tokenCount[owner] >= _value, "INSUFFICIENT TOKEN");
        require(msg.sender == owner, "NOT THE OWNER");
        tokenCount[owner] -= _value;
        tokenCount[_to] += _value;
        //tokenbalance[msg.sender].amount = _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }*/

  /*function writeReview(string memory newReview) public {
      require(tokenCount[msg.sender] == 1, "NOT ELIGIBLE FOR REVIEW");
      productReview = newReview;
      //console.log(msg.sender,"set review to",productReview);
      emit SetReview(msg.sender, productReview);
  }*/

  function reviewProduct(uint skuId, string memory review) public
    {
           //require(tokencontract.reviewtoken(msg.sender,1), "Token check failed"); //reviewer possess token to review
           //require(products[skuId].isExist == true, "Product Not Exist");
           require(tokenCount[msg.sender] == 1, "NOT ELIGIBLE FOR REVIEW");
           require(products[skuId].productUserReview[msg.sender].isPurchased == true, "You are not eligible to review this product");
           require(products[skuId].productUserReview[msg.sender].doneReview == false, "You have Already reviewed this product");
             
           products[skuId].productUserReview[msg.sender].doneReview = true;
           //products[skuId].productUserReview[msg.sender].reviewDescription = review;
           products[skuId].productUserReview[msg.sender].timeStamp = block.timestamp;
           //tokencontract.reviewed();
           products[skuId].reviewsCount ++;
           products[skuId].rater = msg.sender;
              products[skuId].reviews.push(review);
           // require(tokencontract.burn(1), "Burning failed");
           tokenCount[msg.sender]--;
           
    }

  /*function getLatestUserReview(uint skuId, address user) public view returns (string memory review)
    {
       return products[skuId].productUserReview[user].reviewDescription;
    }*/
    
    function getAReview(uint skuId, uint index) public view returns (string memory review, address reviewer)
    {
       review = products[skuId].reviews[index];
       reviewer = products[skuId].rater;
    }
    function getReviewsCountOfaProduct(uint skuId) public view returns (uint)
    {
       return products[skuId].reviewsCount;
    }
    /*function getAProduct(uint index) public view returns (uint skuId, string memory name, string memory description, uint256 priceWei, uint256 quantity)
    {
       skuId = products[productIds[index]].id;
       name = products[productIds[index]].name;
       description = products[productIds[index]].description;
       priceWei = products[productIds[index]].priceWei;
       quantity = products[productIds[index]].quantity;
       
    }*/

  function owner_Withdraw() public onlyOwner{
    payable(msg.sender).transfer(address(this).balance);
  }

  /*mapping (address => string) public attestations;
  function attest(string memory hash) public {
    console.log(msg.sender, "attests to", hash);
    emit Attest(msg.sender, hash);
    attestations[msg.sender] = hash;
  }
  event Attest(address sender, string hash);*/
}
