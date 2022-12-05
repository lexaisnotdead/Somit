// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./PetFactory.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./IFoodForPets.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

abstract contract Store is PetFactory, ReentrancyGuard {
    using SafeMath for uint256;

    struct ItemInfo {
        bool exists;
        uint price;
    }

    mapping(uint=>ItemInfo) itemToPrice;

    IERC20 public SMTtoken;
    IFoodForPets public foodsContract;
    uint public itemsCount;
    uint public randomPetPrice;
    uint public specificPetPrice;

    constructor(IERC20 _SMTaddress, uint _randomPetPrice, uint _specificPetPrice, IFoodForPets _foodContractAddress) {
        itemsCount = 0;
        SMTtoken = _SMTaddress;
        randomPetPrice = _randomPetPrice;
        specificPetPrice = _specificPetPrice;
        foodsContract = _foodContractAddress;
    }

    event AddItem(address indexed operator, uint indexed price);

    event ModifyItem(address indexed operator, uint id, uint indexed oldPrice, uint indexed newPrice);

    event BuyRandomPet(address indexed owner, uint indexed id);

    event BuySpecificPet(address indexed owner, uint indexed id);

    event BuyFood(address indexed player, uint[] indexed ids, uint[] indexed amounts);

    function addItem(uint _price) external onlyAllowed {
        itemToPrice[itemsCount] = ItemInfo(true, _price);
        itemsCount.add(1);

        emit AddItem(msg.sender, _price);
    }

    function modifyItem(uint _id, uint _newPrice) external onlyAllowed {
        require(itemToPrice[_id].exists, "This item does not exist");
        uint oldPrice = itemToPrice[_id].price;
        itemToPrice[_id] = ItemInfo(true, _newPrice);

        emit ModifyItem(msg.sender, _id, oldPrice, _newPrice);
    }

    function buyRandomPet(string memory _name) external nonReentrant returns(uint id) {
        require(SMTtoken.transferFrom(msg.sender, address(this), randomPetPrice), "Insufficient funds");
        id = _createRandomPet(_name, msg.sender);

        emit BuyRandomPet(msg.sender, id);
    }

    function buySpecificPet(uint _dna, string memory _name) external nonReentrant returns(uint id) {
        require(SMTtoken.transferFrom(msg.sender, address(this), specificPetPrice), "Insufficient funds");
        id = _craeteNewPet(_name, _dna, msg.sender);

        emit BuySpecificPet(msg.sender, id);
    }

    function buyFood(uint[] calldata _ids, uint[] calldata _amounts) external nonReentrant {
        require(_ids.length == _amounts.length);

        uint totalPrice = 0;
        for (uint i = 0; i < _ids.length; ++i) {
            require(itemToPrice[_ids[i]].exists, "At least one item does not exist");

            totalPrice += itemToPrice[_ids[i]].price * _amounts[i];
        }

        require(SMTtoken.transferFrom(msg.sender, address(this), totalPrice), "Insufficient funds");
        foodsContract.mintBatch(msg.sender, _ids, _amounts);

        emit BuyFood(msg.sender, _ids, _amounts);
    }
}