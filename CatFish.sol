// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

contract CatFish {
    string public tokenName;
    string public tokenSymbol;
    uint8 public tokenDecimal;
    int public maxSupply;
    address private owner;
    address public payer;
    uint public value;
    address public origin; 
    address public minter;
    mapping (address => uint) public balance;
    event send(address from, address to, uint amount);

    constructor() {
        tokenName = "CATFISH";
        tokenSymbol = "CatFish";
        tokenDecimal = 18;
        maxSupply = 1000000;
        minter = msg.sender;
        owner = msg.sender;       
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller must be owner");
        _;
    }

    function mint(address receiver, uint amount) public {
        require(msg.sender == minter);
        require(amount < 1e60);
        balance[receiver] += amount;
    }

    function sent(address receiver, uint amount) public {
        require(amount <= balance[msg.sender], "Insufficient Balance");
        balance[msg.sender] -= amount;
        balance[receiver] += amount;
        emit send(msg.sender, receiver, amount);
    }

    function pay() public payable {  
        payer = msg.sender;
        origin = tx.origin;
        value = msg.value;
        
    }
    
    function balances(address _account) external view returns (uint) {
        return balance[_account];
    }

    function getBlockInfo() public view returns (uint, uint, uint) {
        return (
            block.timestamp,
            block.number,
            block.chainid
        );
    }

    function checkBalance() public view returns (uint) {
        return address (this).balance;
    }
}