// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/// @title Lottery Interface
/// @notice 定义 Lottery 合约的核心功能接口
interface ILottery {
    // ---------------------------
    // 玩家操作
    // ---------------------------

    /// 玩家存款到合约
    /// @dev msg.value 为存入金额
    function deposit() external payable;

    /// 玩家下注
    /// @param amount 下注金额（必须 <= 玩家余额）
    function bet(uint256 amount) external;

    /// 玩家提现
    /// @param amount 提现金额
    function withdraw(uint256 amount) external;

    /// 查询玩家余额
    /// @param player 玩家地址
    /// @return 余额
    function getBalance(address player) external view returns (uint256);

    /// 查询玩家最近下注金额
    /// @param player 玩家地址
    /// @return 最近下注金额
    function lastBet(address player) external view returns (uint256);

    // ---------------------------
    // 管理员操作
    // ---------------------------

    /// 管理员结算奖池
    /// @param winner 玩家地址
    function settle(address winner) external;

    /// 管理员向奖池增加 ETH
    function adminAddToPot() external payable;

    // ---------------------------
    // 奖池查询
    // ---------------------------

    /// 查询当前奖池余额
    /// @return 奖池金额
    function currentPot() external view returns (uint256);
}