# vitalikPlace: Your NFT Marketplace

## What is vitalikPlace?

vitalikPlace is a smart contract that creates a marketplace for buying and selling NFTs (Non-Fungible Tokens) on the Ethereum blockchain. Think of it as an online marketplace, but for unique digital items.

## What can you do with vitalikPlace?

1. Sell your NFTs: If you have an NFT, you can put it up for sale.
2. Buy NFTs: You can purchase NFTs that others have put up for sale.
3. Change the price: If you're the seller, you can change the price of your NFT.
4. Cancel the sale: If you change your mind, you can remove your NFT from the sale.

## How it works

### To sell an NFT:
1. Use the listNFT function
2. Tell the contract which NFT you want to sell and at what price

### To buy an NFT:
1. Use the buyNFT function
2. Send enough Ether to cover the price

### To change the price:
1. Use the updatePrice function
2. Specify the new price you want

### To cancel the sale:
1. Use the unlistNFT function

## Important tips

- Make sure you have permission to sell the NFT before listing it.
- When buying, send the exact amount of Ether that the NFT costs.
- Only the owner of an NFT can list it or change its price.
- Once you sell an NFT, the sale is final and cannot be undone.

## Security

The contract has security measures to protect your NFTs and your money, but always be careful when using smart contracts.

## For developers

This contract uses Solidity version 0.8.26 and depends on OpenZeppelin contracts. Make sure you have everything set up before deploying it.

## Remember

This is a real contract that handles real NFTs and Ether. Use it carefully, and if you have doubts, ask someone with experience in smart contracts for help.

##Team members

https://github.com/AnoukRImola/ethkipu-marketplace-nft
https://github.com/PabloVillaplana/ethkipu-marketplace-nft
