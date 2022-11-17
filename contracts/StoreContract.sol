// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./PetFactory.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

abstract contract Store is PetFactory {
    using SafeMath for uint256;

    struct ItemInfo {
        bool exists;
        uint price;
    }

    mapping(uint=>ItemInfo) itemToPrice;

    IERC20 public SMTtoken;
    uint public itemsCount;
    uint public randomPetPrice;
    uint public specificPetPrice;

    constructor(IERC20 _SMTaddress, uint _randomPetPrice, uint _specificPetPrice) {
        itemsCount = 0;
        SMTtoken = _SMTaddress;
        randomPetPrice = _randomPetPrice;
        specificPetPrice = _specificPetPrice;
    }

    function addItem(uint _price) public onlyOwnerOrGame {
        itemToPrice[itemsCount] = ItemInfo(true, _price);
        itemsCount.add(1);
    }

    function modifyItem(uint _id, uint _newPrice) public onlyOwnerOrGame {
        require(itemToPrice[_id].exists, "This item does not exist");
        itemToPrice[_id] = ItemInfo(true, _newPrice);
    }

    function buyRandomPet(string memory _name) public returns(uint) {
        require(SMTtoken.transferFrom(msg.sender, address(this), randomPetPrice), "Insufficient funds");

        return _createRandomPet(_name, msg.sender);
    }

    function buySpecificPet(uint _dna, string memory _name) public returns(uint) {
        require(SMTtoken.transferFrom(msg.sender, address(this), specificPetPrice), "Insufficient funds");

        return _craeteNewPet(_name, _dna, msg.sender);
    }

    function purchase(uint _id) public returns(uint) {

    }

    

}