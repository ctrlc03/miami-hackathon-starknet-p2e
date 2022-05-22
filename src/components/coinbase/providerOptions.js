
import WalletConnect from "@walletconnect/web3-provider";
import CoinbaseWalletSDK from "@coinbase/wallet-sdk";

export const providerOptions = {
  walletlink: {
    package: CoinbaseWalletSDK, // Required
    options: {
      appName: "Web 3 Modal Demo", // Required
      infuraId: 'https://mainnet.infura.io/v3/cc90ecef333a4af99efd726d0220610a' // Required unless you provide a JSON RPC url; see `rpc` below
    }
  },
  walletconnect: {
    package: WalletConnect, // required
    options: {
      infuraId: 'https://mainnet.infura.io/v3/cc90ecef333a4af99efd726d0220610a' // required
    }
  }
};
