// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract KnowYourToken is ERC20 {
    constructor() ERC20("KnowYourToken", "KYT") {}

    function mint(address account, uint256 amount) public {
        _mint(account, amount);
    }
}
