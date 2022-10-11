// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract FoodForPets is ERC1155, Ownable {
  constructor() ERC1155("") {}

  enum Foods {
    Banana,
    Sandwich,
    Pizza,
    Orange,
    Salad
  }

  struct Food {
    uint8 foodType;
    uint8 healthyness;
  }

  

}
