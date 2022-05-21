import { useStarknet, useStarknetInvoke } from '@starknet-react/core'
import React from 'react'
import { useGameContract } from '../../hooks/gameLib'
// import { shortStringToFelt } from "../../commons/converters"

export function RewardToken() {
  const { account } = useStarknet()
  const { contract: gameContract } = useGameContract()
  const { invoke } = useStarknetInvoke({ contract: gameContract, method: 'reward_tokens' })

  // shortStringToFelt(input: account)
  console.log(account)

  if (!account) {
    return null
  }


  return (
    <div>
      <button
        onClick={() =>
          invoke({
            args: [''],
            metadata: { method: 'reward_tokens', message: 'Reward Tokens' },
          })
        }
      >
        Reward Token
      </button>
    </div>
  )
}