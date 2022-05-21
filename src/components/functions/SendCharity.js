import { useStarknet, useStarknetInvoke } from '@starknet-react/core'
import React from 'react'
import { useGameContract } from '../../hooks/gameLib'


export function SendCharity() {
  const { account } = useStarknet()
  const { contract: gameContract } = useGameContract()
  const { invoke } = useStarknetInvoke({ contract: gameContract, method: 'send_to_charity' })

  if (!account) {
    return null
  }


  return (
    <div>
      <button
        onClick={() =>
          invoke({
            args: ['0x05280beb66d2b539767dbd05ed8986609bca126bac9653f2f1ff2e765325c605', 500, '0x03bf1980165b6397754637964f4384b29c10cc751e25e9257ff6dfb3c78ac512'],
            metadata: { method: 'send_to_charity', message: 'Funds are sent to chosen charity' },
          })
        }
      >
        Send the Funds to the chosen Charity
      </button>
    </div>
  )
}



