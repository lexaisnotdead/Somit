// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

contract Ownable {
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    event GameContractTransferred(address indexed previousGameContract, address indexed newGameContract);

    event StoreContractTransferred(address indexed previousStoreContract, address indexed newStoreContract);

    address private owner;
    address private gameContract;
    address private storeContract;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwnerOrGame() {
        require(owner == msg.sender || gameContract == msg.sender, "Ownable: caller is not authorized");
        _;
    }

    modifier onlyOwnerOrStore() {
        require(msg.sender == owner || msg.sender == storeContract, "Ownable: caller is not authorized");
        _;
    }

    modifier onlyAllowed {
        require(msg.sender == owner || msg.sender == storeContract || msg.sender == gameContract);
        _;
    }

    function transferOwnership(address _newOwner) public onlyAllowed {
        require(_newOwner != address(0), "Ownable: new owner is the zero address");
        
        _transferOwnership(_newOwner);
    }

    function _transferOwnership(address _newOwner) internal {
        address oldOwner = owner;
        owner = _newOwner;

        emit OwnershipTransferred(oldOwner, _newOwner);
    }

    function newGameContract(address _newGameContract) public onlyAllowed {
        require(_newGameContract != address(0), "Ownable: new game contract is the zero address");

        _transferGameContract(_newGameContract);
    }

    function _transferGameContract(address _newGameContract) internal {
        address oldGameContract = gameContract;
        gameContract = _newGameContract;

        emit GameContractTransferred(oldGameContract, _newGameContract);
    }

    function newStoreContract(address _newStoreContract) public onlyAllowed {
        require(_newStoreContract != address(0), "Ownable: new store contract is zero address");

        _transferStoreContract(_newStoreContract);
    }

    function _transferStoreContract(address _newStoreContract) internal {
        address oldStoreContract = storeContract;
        storeContract = _newStoreContract;

        emit StoreContractTransferred(oldStoreContract, _newStoreContract);
    }
}