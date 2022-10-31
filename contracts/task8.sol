// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 *  @title UserBalance
 *. @notice Simple balance with real ETH, any user can update its balance
 */
contract UserBalance {
    mapping(address => uint256) public balances;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function checkBalance() public view returns (uint256) {
        return (balances[msg.sender]);
    }

    fallback() external payable {}

    receive() external payable {}
}
