// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./FoodsDeclaration.sol";

contract FoodForPets is ERC1155, Ownable {
  event Minted(address indexed operator, Foods indexed id, uint indexed amount);

  event MintedBatch(address indexed operator, uint[] indexed ids, uint[] indexed amounts);

  event SetFood(address indexed operator, Foods indexed id, uint indexed healthyness);

  mapping(Foods => uint8) public foodInfo; // foodType to healthyness;

  constructor() ERC1155("") Ownable() {
    foodInfo[Foods.Banana] = 8;
    foodInfo[Foods.Sandwich] = 5;
    foodInfo[Foods.Pizza] = 3;
    foodInfo[Foods.Orange] = 9;
    foodInfo[Foods.Sushi] = 9;
    foodInfo[Foods.Salad] = 10;
  }

  function mint(address to, Foods id, uint amount) external onlyOwnerOrStore {
    _mint(to, uint(id), amount, "");

    emit Minted(msg.sender, id, amount);
  }

  function mintBatch(address to, uint[] calldata ids, uint[] calldata amounts) external onlyOwnerOrStore {
    for (uint i = 0; i < ids.length; ++i) {
      require(ids[i] >= uint(Foods.Banana) && ids[i] <= uint(Foods.Salad));
    }

    _mintBatch(to, ids, amounts, "");

    emit MintedBatch(msg.sender, ids, amounts);
  }

  function setFood(Foods _id, uint8 _healthyness) external onlyAllowed {
    require(_healthyness <= 10);
    foodInfo[_id] = _healthyness;

    emit SetFood(msg.sender, _id, _healthyness);
  }
}
