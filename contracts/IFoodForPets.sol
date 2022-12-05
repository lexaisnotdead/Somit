// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import './FoodForPets.sol';
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "./FoodsDeclaration.sol";

interface IFoodForPets is IERC1155 {
    function mint(address to, Foods id, uint amount) external;
    
    function mintBatch(address to, uint[] calldata ids, uint[] calldata amounts) external;

    function setFood(Foods _id, uint8 _healthyness) external;
}