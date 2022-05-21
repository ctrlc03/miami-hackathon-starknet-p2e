import { useContract } from '@starknet-react/core'
import { Abi } from 'starknet'

import Erc20Abi from '../artifacts/abis/ERC20.json'

export function useTokenContract() {
  return useContract({
    abi: Erc20Abi as Abi,
    address: '0x06a7ca32fea7a10ac5e99c7b7ad255d33e00ecbe20b8630de80010b857ffa7fa',
  })
}