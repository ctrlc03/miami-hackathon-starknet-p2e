require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-waffle");

const main = async () => {

    const [deployer] = await hre.ethers.getSigners();

    const WinnerNFTContractFactory = await hre.ethers.getContractAt("ERC721", process.argv[2]);
    await WinnerNFTContractFactory.mint(process.argv[3], process.argv[4], 420);
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
