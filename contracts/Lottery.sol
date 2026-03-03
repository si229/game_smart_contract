// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


struct PlayerBetInfo {
    address account;
    BetInfo[] betInfo;
}


struct BetInfo {
    uint8 zone;
    uint16 amount;
}


contract Lottery is Ownable, ReentrancyGuard {
    IERC20 public usdt; 
    constructor(address _usdt) Ownable(msg.sender) {  usdt = IERC20(_usdt);}
    
    mapping(address => uint256) public balances;

    uint256 public currentPot;

    mapping(address => BetInfo[]) public playerBet;

    event Deposit(address indexed player, uint256 amount);
    event Bet(address indexed player, uint256 amount);
    event Settle(address indexed winner, uint256 amount);
    event Withdraw(address indexed player, uint256 amount);
    event AdminAddToPot(uint256 amount);

    function deposit() external payable {
        require(msg.value > 0, "Must send ETH");
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }


        function bet(PlayerBetInfo[] calldata playerBetInfoList) external {
            for (uint i = 0; i < playerBetInfoList.length; i++) {
                address player = playerBetInfoList[i].account;

                for (uint j = 0; j < playerBetInfoList[i].betInfo.length; j++) {
                    uint8 zone = playerBetInfoList[i].betInfo[j].zone;
                    uint16 amount = playerBetInfoList[i].betInfo[j].amount;

                    // 余额不足跳过
                    if (balances[player] < amount) {
                        continue;
                    }

                    balances[player] -= amount;

                    // 直接 push struct 到 storage
                    playerBet[player].push(BetInfo({zone: zone, amount: amount}));
                }
            }
        }


    /// 管理员结算奖池给指定玩家
    function settle(address winner) external onlyOwner {
        require(currentPot > 0, "No pot to settle");
        require(winner != address(0), "Invalid winner");

        balances[winner] += currentPot;
        emit Settle(winner, currentPot);
        currentPot = 0;
    }

    /// 玩家提现
    function withdraw(uint256 amount) external nonReentrant {
        require(balances[msg.sender] >= amount, "Insufficient balance");

        balances[msg.sender] -= amount;
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed");

        emit Withdraw(msg.sender, amount);
    }

    /// 管理员增加奖池（可直接转 ETH 给合约）
    function adminAddToPot() external payable onlyOwner {
        require(msg.value > 0, "Must send ETH");
        currentPot += msg.value;
        emit AdminAddToPot(msg.value);
    }

    /// 查看玩家余额（可选）
    function getBalance(address player) external view returns (uint256) {
        return balances[player];
    }
}