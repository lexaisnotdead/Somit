// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

abstract contract Ownable {
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    event GameContractTransferred(address indexed previousGameContract, address indexed newGameContract);

    address private owner;
    address private gameContract;

    constructor(address _gameContract) {
        owner = msg.sender;
        gameContract = _gameContract;
    }

    modifier onlyOwnerOrGame() {
        require(owner == msg.sender || gameContract == msg.sender, "Ownable: caller is not authorized");
        _;
    }

    function transferOwnership(address _newOwner) public onlyOwnerOrGame {
        require(_newOwner != address(0), "Ownable: new owner is the zero address");
        
        _transferOwnership(_newOwner);
    }

    function _transferOwnership(address _newOwner) internal {
        address oldOwner = owner;
        owner = _newOwner;

        emit OwnershipTransferred(oldOwner, _newOwner);
    }

    function newGameContract(address _newGameContract) public onlyOwnerOrGame {
        require(_newGameContract != address(0), "Ownable: new game contract is the zero address");

        _transferGameContract(_newGameContract);
    }

    function _transferGameContract(address _newGameContract) internal {
        address oldGameContract = gameContract;
        gameContract = _newGameContract;

        emit GameContractTransferred(oldGameContract, _newGameContract);
    }
}