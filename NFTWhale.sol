pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC1155/SafeERC1155.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// Contract for the "NFT Whale" token
contract NFTWhale is ERC721 {
  // The name of the token
  string public name = 'NFT Whale';

  // The symbol of the token
  string public symbol = 'NFTW';

  // The base URI of the token
  string public baseURI = 'https://example.com/nft-whale/';

  // The maximum supply of NFT Whale tokens
  uint256 public constant maxSupply = 100;

  // Mapping to track the number of NFTs minted by each wallet
  mapping(address => uint256) public minted;

  // The ID of the next NFT Whale to be minted
  uint256 private nextID = 1;

  // Event that is emitted when a new NFT Whale is minted
  event Mint(address indexed to, uint256 id);

  // Event that is emitted when an NFT Whale is transferred
  event Transfer(address indexed from, address indexed to, uint256 id);

  // Event that is emitted when an NFT Whale is burned
  event Burn(address indexed from, uint256 id);

  // Constructor function
  constructor() public {
    // Set the name, symbol, and base URI of the token
    _setName(name);
    _setSymbol(symbol);
    _setBaseURI(baseURI);
  }

  // Modifier to only allow the contract owner to call a function
  modifier onlyOwner() {
    require(msg.sender == owner, 'Only the contract owner can call this function.');
    _;
  }

  // Function to mint a new NFT Whale and add it to the given wallet
  function mint(address to) public onlyOwner {
 
 // Check if the given wallet has already minted an NFT Whale
    require(minted[to] == 0, 'This wallet has already minted an NFT Whale.');

    // Check if the maximum supply of NFT Whale tokens has been reached
    require(totalSupply() < maxSupply, 'The maximum supply of NFT Whale tokens has been reached.');

    // Mint the new NFT Whale and add it to the given wallet
    _mint(to, nextID);

    // Increment the number of NFTs minted by the given wallet
    minted[to]++;

    // Emit the Mint event
    emit Mint(to, nextID);

    // Increment the ID of the next NFT Whale to be minted
    nextID++;
  }
