// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/// @title Player 管理合约
/// @notice 存储玩家余额和下注记录，提供接口给 Lottery 合约调用
contract Player {
    /// 玩家余额
    mapping(address => uint256) private _balances;

    /// 玩家最近下注金额
    mapping(address => uint256) private _lastBet;

    /// 事件
    event BalanceUpdated(address indexed player, uint256 newBalance);
    event LastBetUpdated(address indexed player, uint256 amount);

    /// 查询余额
    function balanceOf(address player) external view returns (uint256) {
        return _balances[player];
    }

    /// 内部增加余额
    function _addBalance(address player, uint256 amount) internal {
        _balances[player] += amount;
        emit BalanceUpdated(player, _balances[player]);
    }

    /// 内部减少余额
    function _subtractBalance(address player, uint256 amount) internal {
        require(_balances[player] >= amount, "Insufficient balance");
        _balances[player] -= amount;
        emit BalanceUpdated(player, _balances[player]);
    }

    /// 内部记录下注
    function _setLastBet(address player, uint256 amount) internal {
        _lastBet[player] = amount;
        emit LastBetUpdated(player, amount);
    }

    /// 查询最近下注金额
    function lastBet(address player) external view returns (uint256) {
        return _lastBet[player];
    }
}