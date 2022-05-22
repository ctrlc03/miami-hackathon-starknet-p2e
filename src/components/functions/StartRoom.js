import { useStarknet, useStarknetInvoke } from '@starknet-react/core'
import React from 'react'
import { useGameContract } from '../../hooks/gameLib'
import { shortStringToFelt } from "../../commons/converters"

export function StartRoom() {
  const { account } = useStarknet()
  const { contract: gameContract } = useGameContract()
  const { invoke } = useStarknetInvoke({ contract: gameContract, method: 'start_room' })

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
            metadata: { method: 'start_room', message: 'Start Room' },
          })
        }
      >
        Start Room
      </button>
    </div>
  )
}