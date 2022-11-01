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
        bool deposited;
    }
    error AmountToSmall(uint256 available_, uint256 minRequired_);
    error OnlyOwner(address user_, address owner_);
    error OnlyDeposited(address user_);
    error AvailableFunds(uint256 available_, uint256 required_);

    mapping(address => uint256) private balances;
    mapping(address => User) private userDetail;
    address private owner;
    uint256 private FEE;

    constructor(uint256 fee_) {
        owner = msg.sender;
        FEE = fee_;
    }

    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert OnlyOwner({user_: msg.sender, owner_: owner});
        }
        _;
    }

    modifier onlyDeposited() {
        if (userDetail[msg.sender].deposited != true) {
            revert OnlyDeposited(msg.sender);
        }
        _;
    }

    modifier availableFunds(uint256 amount_) {
        if (balances[msg.sender] < amount_) {
            revert AvailableFunds({
                available_: balances[msg.sender],
                required_: amount_
            });
        }
        _;
    }

    modifier availableFee(uint256 amount_) {
        if (amount_ < FEE) {
            revert AmountToSmall({
                available_: balances[msg.sender],
                minRequired_: FEE
            });
        }
        _;
    }

    function deposit(uint256 amount_) external {
        balances[msg.sender] += amount_;
        userDetail[msg.sender].deposited = true;
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

    // @notice withdrawing would be like burning the contract owner's tokens, probably doesn't
    //         make much sense, but it's just an exercise
    function withdraw(uint256 amount_)
        public
        onlyOwner
        availableFunds(amount_)
    {
        balances[msg.sender] -= amount_;
    }

    // @notice similar to funcion depostis but with FEE...
    function addFund(uint256 amount_)
        public
        onlyDeposited
        availableFee(balances[msg.sender])
    {
        balances[msg.sender] -= FEE;
        balances[msg.sender] += amount_;
    }
}
