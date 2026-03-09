// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Baccarat is ReentrancyGuard {
    bytes32 public resultHash;
    address private owner;
    
    uint256 private totalPrizePool;
    uint256 private settlePrizePool;

    mapping(address => uint256) private _balances;

    constructor(){
        owner = msg.sender;
    }

    function getBalance() external view returns (uint256) {
        return _balances[msg.sender];
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    function deposit() external payable {
        require(msg.value > 0, "Deposit amount must be greater than 0");
        _balances[msg.sender] += msg.value;
    }

    function withdraw(uint amount) external nonReentrant {
        require(_balances[msg.sender] >= amount);

        _balances[msg.sender] -= amount;

        (bool success,) = msg.sender.call{value: amount}("");
        require(success);
    }

    function withdrawPrizePool(uint amount) external onlyOwner {
        require(amount>0 && totalPrizePool >= amount, "insufficient prize pool");
        totalPrizePool-=amount;
        (bool success,) = msg.sender.call{value: amount}("");
        require(success);
    }

    function depositPrizePool(uint amount) external onlyOwner {
        require(amount>0 , "Deposit amount must be greater than 0");
        totalPrizePool+=amount;
    }


}