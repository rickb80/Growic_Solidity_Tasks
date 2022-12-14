// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 *  @title UserBalance
 *. @notice Simple balance, any user can update its balance.
 */
contract UserBalance {
    event fundsDeposited(address indexed user_, uint256 indexed amount_);
    event profileUpdated(address indexed user);

    struct User {
        string name;
        uint256 age;
        bool deposited;
    }
    error AmountToSmall(uint256 available, uint256 minRequired);

    mapping(address => uint256) private balances;
    mapping(address => User) private userDetail;
    address private owner;
    uint256 private FEE;

    constructor(uint256 fee_) {
        owner = msg.sender;
        FEE = fee_;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier onlyDeposited() {
        require(
            userDetail[msg.sender].deposited == true,
            "Not previously deposited"
        );
        _;
    }

    modifier availableFunds(uint256 amount_) {
        require(balances[msg.sender] >= amount_, "Not available funds");
        _;
    }

    modifier availableFee() {
        if (balances[msg.sender] < FEE) {
            revert AmountToSmall({
                available: balances[msg.sender],
                minRequired: FEE
            });
        }
        _;
    }

    function deposit(uint256 amount_) external {
        emit fundsDeposited(msg.sender, amount_);
        balances[msg.sender] += amount_;
        userDetail[msg.sender].deposited = true;
    }

    function checkBalance() public view returns (uint256) {
        return (balances[msg.sender]);
    }

    function setUserDetails(string calldata name_, uint256 age_) public {
        emit profileUpdated(msg.sender);
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
    function addFund(uint256 amount_) public onlyDeposited availableFee {
        balances[msg.sender] += amount_ - FEE;
    }
}
