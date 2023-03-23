// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract PetFactory is ERC721, Ownable {
    using SafeMath for uint256;
    uint256 public petsCounter;

    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) Ownable() {
        petsCounter = 0;
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

    function _craeteNewPet(string memory _name, uint _dna, address player) internal returns(uint) {
      uint petId = petsCounter;
      Pets[petId] = Pet(_name, _dna, block.timestamp, block.timestamp, 0, 75);
      _safeMint(player, petId);
      emit NewPet(petId, _name, _dna);
      petsCounter = petsCounter.add(1);
      return petId;
    }

    function _createRandomPet(string memory _name, address player) internal returns(uint) {
      uint randomDNA = _generateRandomDna(_name);
      return _craeteNewPet(_name, randomDNA, player);
    }
}