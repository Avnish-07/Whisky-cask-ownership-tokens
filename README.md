# Whisky-cask-ownership-tokens

## Table of Contents

- [Introduction](#introduction)
- [Features or documentation](#features-or-documentation)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
- [Usage](#usage)
  - [Creating Whiskey Casks](#creating-whiskey-casks)
  - [Listing Fractions](#listing-fractions)
  - [Buying Fractions](#buying-fractions)
  - [Transferring Fractions](#transferring-fractions)
  - [Destruction of Casks](#destruction-of-casks)
- [Smart Contract Details](#smart-contract-details)
- [Deployment](#Deployment)
- [Originality](#Originality)
- [Code quality](#Code-Quality)
- [Challenges Faced](#Challenges-faced)

## Introduction

The Whiskey Token smart contract revolutionizes the way investors engage with the luxury whiskey market by combining blockchain technology and fractional ownership. This decentralized application (DApp) tokenizes ownership of premium whiskey casks, allowing enthusiasts to buy, sell, and trade fractional ownership of rare casks.

## Features or Documentation

### Cask Creation

Enthusiasts can create new whiskey casks through the `create_cask` function. This feature allows users to define the unique properties of a cask, such as its type, refill status, total supply, and price per fraction. Cask creation opens up opportunities for investment and ownership of premium whiskey casks.

### Fraction Listing

Cask owners can list fractions of their casks for sell using the `fraction_for_sell` function. By specifying the cask ID, cask type name, fraction quantity, and price per fraction, owners can attract potential buyers interested in fractional ownership of high-quality casks.

### Listing of Cask Fractions Created by Cask Owners

To view a list of casks and their details created by various owners, you can use the `list_of_cask_fractions_created_by_cask_owners` function. This function returns an array of casks with their respective information.

### Buying Fractions directly by cask owners

Investors can buy fractions of casks using the `buy_cask_fractions` function. Specify the cask ID and the number of fractions you want to purchase. Ensure you send the correct amount of Ether for the transaction.

### Viewing Fractions on Sell

To view a list of fractions that are currently listed for selling, you can use the `list_of_fractions_on_sell` function. This function returns an array of fractions for sell along with their details.

### Buying Fractions from sell listing

The `buy_fractions_from_sell` function facilitates the purchase of cask fractions listed by other users. This feature allows enthusiasts to diversify their whiskey portfolio by acquiring fractions of different casks. Transactions are securely processed, ensuring both parties receive their fair share.

### Canceling Sell Listing

If an investor wishes to remove their fractions from the sell, they can use the `cancel_sell_listing` function. Specify the seller ID of the listing to be canceled. Only the seller who listed the fractions for selling can call this function. The listing will be deleted from the sell list.

### Updating Fraction Price

Cask owners can update the price per fraction of their casks using the `update_fraction_price_of_cask` function. Specify the cask ID and the updated price. Only the cask owner can update the price.

### Transferring Fractions

Address holders with cask fractions can transfer them to other addresses using the `transfer_fractions` function. This functionality promotes liquidity within the ecosystem, enabling users to trade and exchange ownership of cask fractions seamlessly.

### Destruction of Casks

Cask owners can choose to destroy their casks using the `destroy_cask` function. This unique feature ensures that invested funds are returned to token holders, in case of cask is destroyed.

### Redeeming Fractions of Destroyed Cask

If a cask is destroyed, investors can redeem their investments from it using the `redeem_fractions_of_destroyed_cask` function. This function allows investors to withdraw their invested Ether proportional to their fractions from the destroyed cask.

## Getting Started

### Prerequisites

Before you begin, ensure you have met the following requirements:

- Ethereum Development Environment (Remix, Truffle, Hardhat)
- Solidity Compiler (version >=0.5.0 <0.9.0)
- OpenZeppelin Contracts Library (ERC20.sol)


## Usage

### Creating Whiskey Casks

1. Use the `create_cask` function to create a new whiskey cask.
2. Provide the cask type name, refill status, total casks supplying, total fractions, and price per fraction.
3. Once the cask is created, an event (`cask_created`) will be emitted, confirming successful creation.

### Listing Fractions

1. As a cask owner, use the `fraction_for_sell` function to list fractions of your cask for selling.
2. Specify the cask ID, cask type name, fraction quantity, and price per fraction.
3. The contract will emit an event (`fractions_listed_for_sell`) to confirm the listing.

### Buying Fractions

1. Enthusiasts can use the `buy_fractions_from_sell` function to purchase fractions from available listings.
2. Provide the cask ID, desired fraction quantity, and seller ID.
3. The contract validates the purchase and transfers ownership accordingly.

### Transferring Fractions

1. Address holders with cask fractions can transfer them to other addresses using the `transfer_fractions` function.
2. Specify the recipient's address, fraction quantity, and cask ID to initiate the transfer.
3. The contract updates ownership records and emits an event (`fractions_transferred`).

### Destruction of Casks

1. Cask owners can destroy their casks using the `destroy_cask` function.
2. Ensure the account balance is sufficient to return invested funds to token holders.
3. Upon successful destruction, an event (`cask_destroyed`) will be emitted.


## Contract Details

- Contract Name: `whiskey_cask_ownership_tokens`
- Inherited from: `ERC20` (OpenZeppelin)
- Compiler Version: >=0.5.0 <0.9.0
- SPDX-License-Identifier: GPL-3.0

## Deployment

1. Clone this repository to your local machine.
2. Install the required dependencies using `npm install` or your preferred package manager.
3. Update the contract parameters such as compiler version and SPDX license in `whiskey_cask_ownership_tokens.sol` as needed.
4. Deploy the contract to a compatible blockchain network (e.g., Ethereum, Binance Smart Chain) using tools like Remix, Truffle, or Hardhat.

   
## Originality

- This smart contract presents a unique use case of fractional ownership of whiskey casks, catering to whiskey enthusiasts and investors.
- The functionalities of "destroy cask" and "redeem destroyed cask" provide original solutions to address the impact of cask destruction on investors.

## Code Quality

- The contract structure is organized and modular, with clearly defined sections for each functionality.
- Meaningful variable and function names enhance code readability.
- Detailed comments throughout the code explain the purpose and functionality of different components.
- Access control modifiers ensure that only authorized users can perform specific actions.
- Proper input validation is implemented to prevent erroneous or malicious use of functions.
- Gas-efficient data storage mechanisms, such as mappings, optimize the contract's efficiency.
- Code follows consistent naming conventions, enhancing maintainability.

---
## Challenges Faced

### 1. Designing the Smart Contract Structure

Developing the structure of the smart contract presented its own set of challenges. With multiple interrelated data structures and functions, maintaining clarity and ensuring each component serves its purpose effectively required careful planning and architectural decisions.

### 2. Implementing the "Destroy Cask" Functionality

The implementation of the "destroy cask" functionality was particularly challenging due to its irreversible nature and the impact it has on the investors. This feature required careful consideration of various factors:

- **Investor Protection:** Ensuring that the cask owner has invested the required amount before initiating the destruction is crucial to prevent misuse of this functionality.

- **Returning Investments:** The process of returning invested amounts to the investors required intricate balance adjustments, as each investor's contribution and fractions had to be accounted for accurately.

### 3. Adding the "Redeem Destroyed Cask" Functionality

The "redeem destroyed cask" functionality presented a unique challenge, as it involved allowing investors to recover their funds after a cask was destroyed. This required several considerations:

- **Security:** Ensuring that only valid investors could redeem their funds from destroyed casks required robust access control mechanisms.

- **Data Integrity:** Keeping track of investors' fractions of destroyed casks and managing the redemption process accurately without compromising data integrity was a significant hurdle.

- **Balancing Contract Funds:** Handling the transfer of redeemed funds back to investors required meticulous attention to detail to avoid errors and ensure fair distribution.
  
### 4. Implementing Complex Data Management Functions

Several functions involving data management required critical thinking and careful implementation:

#### `list_of_cask_fractions_created_by_cask_owners()`

Retrieving the list of cask fractions created by cask owners demanded meticulous array manipulation. Ensuring that the returned array contained accurate details for each cask required a clear understanding of data structures.

#### `list_of_fractions_on_sell()`

Creating a function to list fractions available for selling required careful iteration through the array of casks on sell. Properly mapping each cask's information to the array element necessitated precise handling of data.

#### `buy_cask_fractions()`

Enabling the purchase of cask fractions involved intricate balance adjustments, ownership transfers, and fraction calculations. Ensuring that the contract correctly updated balances and ownership required thorough testing and validation.

#### `cancel_sell_listing()`

Allowing sellers to cancel their fractions' sell listing required careful mapping manipulation and authorization checks. Ensuring that only the owner of the listed fractions could cancel the listing demanded proper access control.

#### `update_fraction_price_of_cask()`

Enabling cask owners to update the price of cask fractions required secure authorization and accurate price updates. Ensuring that only the owner could modify prices demanded robust access control mechanisms.

---

