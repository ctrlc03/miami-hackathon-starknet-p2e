
require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-waffle");

const main = async () => {
    // gets info of the account used to deploy
    const [deployer] = await hre.ethers.getSigners();
    const accountBalance = await deployer.getBalance();
  
    console.log('Deploying contract with account: ', deployer.address);
    console.log('Account balance: ', accountBalance.toString());
  
    // read contract file
    const luckyContractFactory = await hre.ethers.getContractFactory(
      'ERC721'
    );
    // triggers deployment
    const luckyContract = await luckyContractFactory.deploy("SuperWinnerNFT","SWMFT");
  
    // wait for deployment to finish
    await luckyContract.deployed();
  
    console.log('LuckyNumber contract address: ', luckyContract.address);
  };
  
  const runMain = async () => {
    try {
      await main();
      process.exit(0);
    } catch (error) {
      console.error(error);
      process.exit(1);
    }
  };
  
  runMain();
  