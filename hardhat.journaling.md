## Set up workspace for squad relative

- Try greeter function

  - The hre seem to embed the accounts there, no account connection is required when call gas-paying function

- Upload an asset to IPFS with nemo collector script and token

  - Use cloudfare-ipfs service might give a better speed of loading https://cloudflare-ipfs.com/ipfs/bafybeidcxb3d7r4umwhf2ajvjju33kff4k7vmd6yfzm3n4dywdyjqrnfca/pancakesquad3292.png/

- Examinize pancake squad source code retrieved from bscscan

  - A part of it is hidden and not too open-source: https://ethervm.io/decompile/binance/0x29fe7148636b7ae0b1e53777b28dfbaa9327af8e
  - 0x29fe7148636b7ae0b1e53777b28dfbaa9327af8e is the contract for the user to interact to, then this contract interact with the PancakeSquad contract 0x0a8901b0E25DEb55A87524f0cC164E9644020EBA to mint the work. This contract is the owner of Pancake Squad contract

- found pancake squad, update import statement tmr. use preset auto id instead of the hidden main contract of pancake squad
  - gotta code the master contract on my own, the preset auto id not relevant
  - https://ethereum.stackexchange.com/questions/2498/check-if-contract-variable-is-undefined  all value is init as zerio, no undefined or null
  - to access a contract within a contract, do it via a getter (remember to implement it)
  - they use lock function to finalize config of uri instead of giving it right in the constructor
  - testing with different accounts: https://hardhat.org/tutorial/testing-contracts.html#using-a-different-account
  - switch account using contract by calling connect function of the contract
  - the test of hardhat is the best

----

- Use openzepplin erc721 to make the squad relative in local with some example asset

- Write a script to bulk upload asset then json to ipfs

- Implement loyalty on secondary transfer
