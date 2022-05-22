// ➡️ Load env file
require('dotenv').config();

require("@nomiclabs/hardhat-waffle");

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: '0.8.4',

  networks: {
    hardhat: {
      chainId: 1337,
    },
    testnet_aurora: {
      url: 'https://testnet.aurora.dev',
      accounts: ["0x30b8eaaa28bb983b82b38c43790cec52bb4b8b9be7e0c4cc0f18fd8401fdda4c"],
      chainId: 1313161555,
      gasPrice: 120 * 1000000000
    },
    rinkeby: {
      url: "https://eth-rinkeby.alchemyapi.io/v2/pAOEX6MQXy71PzrwmoquxENCqMIg7y6x",
      accounts: ["70a88844519ba6f685dede94b900ec1b3bcde8238d479048f8ba530a779d04d4"],
    },
    alfajores: {
      url: "https://alfajores-forno.celo-testnet.org",
      accounts: ["70a88844519ba6f685dede94b900ec1b3bcde8238d479048f8ba530a779d04d4"],
      chainId: 44787
    },
    mumbai: {
      url: "https://matic-mumbai.chainstacklabs.com",
      accounts: ["70a88844519ba6f685dede94b900ec1b3bcde8238d479048f8ba530a779d04d4"],
    }
  },
};
