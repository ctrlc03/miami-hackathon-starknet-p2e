require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-waffle");

const main = async () => {

    const [deployer] = await hre.ethers.getSigners();
    const accountBalance = await deployer.getBalance();
    console.log("Balance " + accountBalance);

    const luckyContractFactory = await hre.ethers.getContractAt("ERC721", "0xCb03c359022d8ce8619a2DbeAa73e9e802049F90");
    await luckyContractFactory.mint("0xf4A044ba3FE1372628008b6C83950f07049030d2", 0);
}   
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
