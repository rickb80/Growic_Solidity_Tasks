// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 *  @title UserBalance
 *. @notice Simple balance, any user can update its balance.
 */
contract UserBalance {
    mapping(address => uint256) public balances;

    function deposit(uint256 amount_) external {
        balances[msg.sender] += amount_;
    }

    function checkBalance() public view returns (uint256) {
        return (balances[msg.sender]);
    }
}
