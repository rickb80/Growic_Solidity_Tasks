// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 *  @title UserBalance
 *. @notice Simple balance, any user can update its balance.
 */
contract UserBalance {
    struct User {
        string name;
        uint256 age;
    }

    mapping(address => uint256) public balances;
    mapping(address => User) public userDetail;

    function deposit(uint256 amount_) external {
        balances[msg.sender] += amount_;
    }

    function checkBalance() public view returns (uint256) {
        return (balances[msg.sender]);
    }

    function setUserDetails(string calldata name_, uint256 age_) public {
        userDetail[msg.sender].name = name_;
        userDetail[msg.sender].age = age_;
    }

    function getUserDetail(address user_) public view returns (User memory) {
        return userDetail[user_];
    }
}
