import { useStarknet, useStarknetInvoke } from '@starknet-react/core'
import React from 'react'
import { useGameContract } from '../../hooks/gameLib'
import { shortStringToFelt } from "../../commons/converters"

export function CreatePlayerAccount() {
  const { account } = useStarknet()
  const { contract: gameContract } = useGameContract()
  const { invoke } = useStarknetInvoke({ contract: gameContract, method: 'create_player_accounts' })

  shortStringToFelt(input: account)
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
            metadata: { method: 'create_player_accounts', message: 'Account Created' },
          })
        }
      >
        Create Player Account
      </button>
    </div>
  )
}