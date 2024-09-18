// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract vitalikPlace is ReentrancyGuard {

    struct Listing {
        address seller;
        uint256 price;
    }

    
    mapping(address => mapping(uint256 => Listing)) public listings;

    // Events
    event NFTListed(address indexed nftAddress, uint256 indexed tokenId, address indexed seller, uint256 price);
    event NFTSold(address indexed nftAddress, uint256 indexed tokenId, address indexed buyer, uint256 price);
    event NFTUnlisted(address indexed nftAddress, uint256 indexed tokenId, address indexed seller);
    event NFTPriceUpdated(address indexed nftAddress, uint256 indexed tokenId, uint256 newPrice);


    // List an NFT for sale
    function listNFT(address nftAddress, uint256 tokenId, uint256 price) external nonReentrant {
        require(price > 0, "Price must be greater than zero");
        IERC721 nftContract = IERC721(nftAddress);
        require(nftContract.ownerOf(tokenId) == msg.sender, "You must own the NFT to list it");

        
        nftContract.transferFrom(msg.sender, address(this), tokenId);
        
        
        listings[nftAddress][tokenId] = Listing({
            seller: msg.sender,
            price: price
        });

        emit NFTListed(nftAddress, tokenId, msg.sender, price);
    }

    // Buy an NFT
    function buyNFT(address nftAddress, uint256 tokenId) external payable nonReentrant {
        Listing memory listing = listings[nftAddress][tokenId];

        require(listing.price > 0, "NFT is not listed for sale");
        require(msg.value >= listing.price, "Not enough Ether to cover the asking price");

    
        IERC721(nftAddress).safeTransferFrom(address(this), msg.sender, tokenId);
            
        payable(listing.seller).transfer(listing.price);

        delete listings[nftAddress][tokenId];

        emit NFTSold(nftAddress, tokenId, msg.sender, listing.price);
    }

    // Unlist an NFT
    function unlistNFT(address nftAddress, uint256 tokenId) external nonReentrant {
        Listing memory listing = listings[nftAddress][tokenId];

        require(listing.price > 0, "NFT is not listed for sale");
        require(listing.seller == msg.sender, "You must be the seller to unlist");

        IERC721(nftAddress).safeTransferFrom(address(this), msg.sender, tokenId);

        delete listings[nftAddress][tokenId];

        emit NFTUnlisted(nftAddress, tokenId, msg.sender);
    }


    // Update the price of a listed NFT
    function updatePrice(address nftAddress, uint256 tokenId, uint256 newPrice) external nonReentrant {
        require(newPrice > 0, "Price must be greater than zero");

        Listing storage listing = listings[nftAddress][tokenId];

        // Ensure the NFT is listed for sale
        require(listing.price > 0, "NFT is not listed for sale");

        // Ensure the sender is the seller
        require(listing.seller == msg.sender, "You must be the seller to update the price");

        // Update the price
        listing.price = newPrice;

        emit NFTPriceUpdated(nftAddress, tokenId, newPrice);
    }

    // Get the price of a listed NFT
    function getPrice(address nftAddress, uint256 tokenId) external view returns (uint256) {
        Listing memory listing = listings[nftAddress][tokenId];

        // Ensure the NFT is listed for sale
        require(listing.price > 0, "NFT is not listed for sale");

        return listing.price;
    }
}
