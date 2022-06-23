import { useStarknet, useStarknetInvoke } from '@starknet-react/core'
import React from 'react'
import { useGameContract } from '../../hooks/gameLib'
import { shortStringToFelt } from "../../commons/converters"

export function PlayerJoinRoom() {
  const { account } = useStarknet()
  const { contract: gameContract } = useGameContract()
  const { invoke } = useStarknetInvoke({ contract: gameContract, method: 'player_join_room' })

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
            metadata: { method: 'player_join_room', message: 'Player joined room' },
          })
        }
      >
        Join Room
      </button>
    </div>
  )
}