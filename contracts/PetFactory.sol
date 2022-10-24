// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract PetFactory is ERC721, Ownable {
    address private _storeContract;
    using SafeMath for uint256;
    uint256 public petsCounter;

    constructor(string memory _name, string memory _symbol, address _storeContractAddress) ERC721(_name, _symbol) {
        petsCounter = 0;
        _storeContract = _storeContractAddress;
    }
    
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    
    event NewPet(uint petId, string name, uint dna);

    struct Pet {
      string name;
      uint dna;
      uint lastWalkTS;
      uint lastFeedingTS;
      uint16 level;
      uint8 satisfaction;
    }

    mapping(uint => Pet) Pets; 
    
    function _generateRandomDna(string memory _str) private view returns (uint) {
      uint rand = uint(keccak256(abi.encodePacked(_str)));
      return rand % dnaModulus;
    }

    function _craeteNewPet(string memory _name, uint _dna, address player) internal {
      uint petId = petsCounter;
      Pets[petId] = Pet(_name, _dna, block.timestamp, block.timestamp, 0, 75);
      _safeMint(player, petId);
      emit NewPet(petId, _name, _dna);
      petsCounter = petsCounter.add(1);
    }

    function _createRandomPet(string memory _name, address player) internal {
      require(msg.sender == _storeContract, "Only store contract can create a new pet");
      uint randomDNA = _generateRandomDna(_name);
      _craeteNewPet(_name, randomDNA, player);
    }
}