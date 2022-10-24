// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./PetFactory.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

abstract contract Store is PetFactory {
    using SafeMath for uint256;

    mapping(uint=>uint) Items;
    mapping(address=>uint) balances;

    uint public itemsCount;
    address public SMTaddress;

    constructor(address _SMTaddress) {
        itemsCount = 0;
        SMTaddress = _SMTaddress;
    }

    function addItem(uint _price) public onlyOwner {
        Items[itemsCount] = _price;
        itemsCount.add(1);
    }

    function modifyItem(uint _id, uint _newPrice) public onlyOwner {
        require(Items[_id] > 0, "This item does not exist");
        Items[_id] = _newPrice;
    }

    function buy(uint _id, string memory _name) public {
        require(balances[msg.sender] >= Items[_id], "Insufficient Funds");
        balances[msg.sender] -= Items[_id];

        _createRandomPet(_name, msg.sender);
    }
}