// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./Ownable.sol";

contract SMTtoken is ERC20, Ownable {
    constructor(address _gameContract) ERC20("Somit Token", "SMT") Ownable(_gameContract) {}

    function mint(address _to, uint _amount) external onlyOwnerOrGame {
        _mint(_to, _amount);
    }
}