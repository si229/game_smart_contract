// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Baccarat {
    bytes32 public resultHash;
    address private owner;

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
        require(shoeIndex < 416, "Shoe exhausted");
        _balances[msg.sender] += msg.value;
    }

    function withdraw() external payable {
        _balances[msg.sender] += msg.value;
    }
        // 示例：只有拥有者才能执行的函数
    function withdrawFunds() external onlyOwner {
        // 提现逻辑
    }


    // 从牌靴抽一张牌
    function draw() external returns (uint8) {
        require(shoeIndex < 416, "Shoe exhausted");

        // 用 keccak256(seed + index) 生成伪随机数
        bytes32 rand = keccak256(abi.encodePacked(shoeSeed, shoeIndex));

        // 映射到 52 张牌 (1-52)
        uint8 card = uint8(uint256(rand) % 52) + 1;

        shoeIndex++;

        return card;
    }
}