// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Vault {
    mapping(address user => uint256 amount) public balances;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() external {
        uint256 amount = balances[msg.sender];
        balances[msg.sender] = 0;

        (bool ok, ) = msg.sender.call{value: amount}("");
        require(ok, "Withdraw Failed");
    }

    function flashloan(uint256 amount) external {
        uint256 initialBalance = address(this).balance;

        (bool ok, ) = msg.sender.call{value: amount}("");
        require(ok, "Flashloan Failed");

        uint256 finalBalance = address(this).balance;
        require(
            finalBalance >= initialBalance,
            "Final balance lower than Initial balance"
        );
    }
}
