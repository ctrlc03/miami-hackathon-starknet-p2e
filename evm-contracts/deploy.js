
require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-waffle");

const main = async () => {
    // gets info of the account used to deploy
    const [deployer] = await hre.ethers.getSigners();
    const accountBalance = await deployer.getBalance();
  
    console.log('Deploying contract with account: ', deployer.address);
    console.log('Account balance: ', accountBalance.toString());
  
    // read contract file
    const WinnerNFTFactory = await hre.ethers.getContractFactory(
      'ERC721'
    );
    const superWinnerNFTFactory = await hre.ethers.getContractFactory(
        'WERC721'
    );
    // triggers deployment
    const SuperWinnerNFT = await superWinnerNFTFactory.deploy("SuperWinnerNFT","SWMFT");
    const WinnerNFT = await WinnerNFTFactory.deploy("WinnerNFT", "WNFT");
  
    // wait for deployment to finish
    await SuperWinnerNFT.deployed();
    await WinnerNFT.deployed();

    console.log('SuperWinnerNFT contract address: ', SuperWinnerNFT.address);
    console.log('WinnerNFT contract address: ', WinnerNFT.address)
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
  