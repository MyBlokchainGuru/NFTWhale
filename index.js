// Import the web3.js library
import Web3 from 'web3';

// Set the provider for the web3.js library to be the Ethereum provider injected by the browser (if available)
// or the HTTP provider pointing to the Rinkeby test network
const web3 = new Web3(window.ethereum || 'https://rinkeby.infura.io/v3/<your-api-key>');

// Import the contract ABI for the ERC721 token contract
import erc721TokenABI from './ERC721Token.json';

// Set the address of the ERC721 token contract
const erc721TokenContractAddress = '0x123456...';

// Create a contract instance for the ERC721 token contract
const erc721TokenContract = new web3.eth.Contract(erc721TokenABI, erc721TokenContractAddress);

// Function to handle the submission of the sign-in form
const handleSignInFormSubmit = async event => {
  // Prevent the form from refreshing the page
  event.preventDefault();

  // Get the signed message from the input field
  const signedMessage = document.getElementById('signed-message').value;

  // Extract the wallet address from the signed message
  const message = 'I am signing in to the NFT webapp.';
  const walletAddress = await web3.eth.personal.ecRecover(message, signedMessage);

  // Check the number of NFTs in the user's wallet using the Moralis API
  const response = await fetch(`https://api.moralis.io/v1/getwalletnfts/${walletAddress}`);
  const nftCount = await response.json();

  // Display the number of NFTs in the user's wallet
  document.getElementById('nft-count').innerHTML = nftCount;

  // If the user has more than 100 NFTs, enable the "Mint NFT Whale" button
  if (nftCount >= 100) {
    document.getElementById('mint-nft-button').disabled = false;
  }
};

// Function to handle the click on the "Mint NFT Whale" button
const handleMintNFTButtonClick = async () => {
  // Get the signed message from the input field
  const signedMessage = document.getElementById('signed-message').value;

  // Extract the wallet address from the signed message
  const message = 'I am signing in to the NFT webapp.';
  const walletAddress = await web3.eth.personal.ecRecover(message, signedMessage);

  // Mint a new "NFT Whale" NFT and add it to the user's wallet
  const tx = await erc721TokenContract.methods.mint('NFT Whale').send({ from: walletAddress });

  // Wait for the transaction to be mined
  await tx.wait();

  // Display a success message
  alert('Your NFT Whale has been minted and added to your wallet!');
};
