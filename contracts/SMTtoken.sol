// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./Ownable.sol";

contract SMTtoken is ERC20, Ownable {
    constructor() ERC20("Somit Token", "SMT") Ownable() {}

    event Mint(address indexed operator, address indexed to, uint indexed amount);

    function mint(address _to, uint _amount) external onlyOwnerOrGame {
        _mint(_to, _amount);

        emit Mint(msg.sender, _to, _amount);
    }
}