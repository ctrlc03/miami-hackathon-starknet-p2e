%lang starknet 

# Imports 
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_lt, uint256_add, uint256_le , uint256_check 
from starkware.cairo.common.math import assert_lt, assert_not_zero
from starkware.cairo.common.math_cmp import is_le 
from starkware.cairo.common.pow import pow 
from starkware.starknet.common.syscalls import (get_contract_address, get_caller_address)

# Ownable stuff
from openzeppelin.access.ownable import (
    Ownable_initializer,
    Ownable_only_owner,
)

from utils.game_owner import (
    Ownable_game_owner_initializer,
    Ownable_get_game_owner,
    Ownable_only_game_owner
)

# Pausable stuff
from openzeppelin.security.pausable import (
    Pausable_paused,
    Pausable_pause,
    Pausable_unpause,
    Pausable_when_not_paused
)

from openzeppelin.security.safemath import (
    uint256_checked_sub_le, 
    uint256_checked_add, 
    uint256_checked_div_rem, 
    uint256_checked_mul)

# ERC20 Stuff 
from openzeppelin.token.erc20.interfaces.IERC20 import IERC20 

# The constructor 
@constructor
func constructor{
        syscall_ptr: felt*, 
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(
        owner: felt,
        token_address : felt,
    ):
    with_attr error_message("Owner cannot be the zero address"):
        assert_not_zero(owner)
    end 

    with_attr error_message("Token Address cannot be the zero address"):
        assert_not_zero(token_address)
    end 

    # set the owner of the contract
    Ownable_initializer(owner)
    # write the token address to storage 
    token_address_storage.write(token_address)

    return ()
end


# STRUCTS 

# Game struct 
struct Game:
  member game_name : felt
  member game_max_players : Uint256
  member game_min_players : Uint256
  member max_number_of_rooms : Uint256
  member state : felt
  member entry_price : Uint256
  member duration : felt 
end

# room struct 
struct Room:
  member prize : Uint256
  member entry_price : Uint256
  member game_name : felt
  member winner_address : felt
  member high_score : Uint256
  member start_time : felt 
  member current_number_of_players : Uint256
  member has_started : felt 
end

# player struct 
struct Player:
    member address : felt 
    member username : felt 
    member total_winnings : Uint256
    member amount_donated : Uint256
end 

###  
### STORAGE
### VARIABLES
###

## 
## HELPERS 
##

# storage for the ecosystem token address
@storage_var
func token_address_storage() -> (address : felt):
end 

@storage_var 
func nft_address_storage() -> (address : felt):
end 

## GAMES 

# mapping of all available games 
@storage_var
func games_mapping(game_id : Uint256) -> (game : Game):
end

# Counter of the amount of games 
@storage_var
func game_id_counter() -> (game_id : Uint256):
end

## Rooms 

# mapping of all available rooms 
@storage_var 
func rooms_mapping(room_id : Uint256) -> (room : Room):
end 

# maps games to their room 
@storage_var
func game_to_room_ids(game_id : Uint256, index : Uint256) -> (room_id : Uint256):
end

# index of room for each game 
@storage_var
func game_to_room_ids_length(game_id : Uint256) -> (length : Uint256):
end

## Players 

@storage_var 
func players(account : felt) -> (player : Player):
end 

@storage_var
func players_to_room(player_account : felt, index : Uint256) -> (room_id : Uint256):
end 

@storage_var 
func players_to_room_length(player_account : felt) -> (length : Uint256):
end 

# EXTERNAL FUNCTIONS 

### 
### GAMES
### 


# Games will be active straight away upon creation
@external
func create_new_game{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr,
    }(
        game_name : felt,
        game_max_players : Uint256,
        game_min_players : Uint256,
        max_number_of_rooms : Uint256,
        game_owner : felt,
        entry_price : Uint256,
        duration : felt 
    ) -> (success : felt):
    alloc_locals
    # check if owner is calling this
    Ownable_only_owner()

    # uint256 checks 
    with_attr error_message("game_max_players is not a valid Uint256"):
        uint256_check(game_max_players)
    end 

    with_attr error_message("game_min_players is not a valid Uint256"):
        uint256_check(game_min_players)
    end 

    with_attr error_message("max_number_of_rooms is not a valid Uint256"):
        uint256_check(max_number_of_rooms)
    end 

    with_attr error_message("entry_price is not a valid Uint256"):
        uint256_check(entry_price)
    end

    # Get the current game ID
    let (local current_game_id : Uint256) = game_id_counter.read()
    local one : Uint256 = Uint256(1, 0)

    # create the game object
    local game : Game = Game(
      game_name=game_name,
      game_max_players=game_max_players,
      game_min_players=game_min_players,
      max_number_of_rooms=max_number_of_rooms,
      state=1,
      entry_price=entry_price,
      duration=duration
    )

    # calculate new counter
    let (local new_counter) = uint256_checked_add(current_game_id, one)

    # set the owner of the game
    Ownable_game_owner_initializer(game_owner, new_counter)
  
    # write game to storage
    games_mapping.write(new_counter, value=game)
    # increase game counter
    game_id_counter.write(new_counter)

    tempvar syscall_ptr = syscall_ptr
    tempvar pedersen_ptr = pedersen_ptr
    tempvar range_check_ptr = range_check_ptr

    return (1)
end

# change the game state
@external
func toggle_game_state{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr,
    }(
      game_id : Uint256,
      new_state : felt
    ) -> (state : felt):

    alloc_locals

    with_attr error_message("new state is not a valid value - 1 or 0"):
        assert_lt(new_state, 2)
    end 

    # check that the game owner is calling it
    Ownable_only_game_owner(game_id=game_id)

    # get the game
    let (local game : Game) = games_mapping.read(game_id=game_id)

    # overwrite the state
    # create a new game for until until we figure out how to modify the struct 
        # create the game object
    local updated_game : Game = Game(
      game_name=game.game_name,
      game_max_players=game.game_max_players,
      game_min_players=game.game_min_players,
      max_number_of_rooms=game.max_number_of_rooms,
      state=new_state,
      entry_price=game.entry_price,
      duration=0 
    )

    # write back the game to its original place 
    games_mapping.write(game_id=game_id, value=updated_game)

    return (new_state)

end

# Remove a game 
@external 
func remove_game{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr,
    } (game_id : Uint256):

    alloc_locals

    # authorization checks 
    #Ownable_only_game_owner(game_id=game_id)

    # will need to remove from so many places 
    # will need to check if the game has any rooms active first 

    return ()
end 

### 
### ROOMS
###


# settle_winner Only_Owner()

# function or game owner only
@external
func create_room_for_game{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr,
    } (
      game_id : Uint256,
      entry_price : Uint256,
      game_name : felt,
    ) -> (room_id : Uint256):
    alloc_locals

    # owner check 
    Ownable_only_game_owner(game_id)
    # read the insertion index
    let (local insertion_index) = game_to_room_ids_length.read(game_id)

    # zero to set to non initiliazed
    local zero : Uint256 = Uint256(0, 0)

    # create a room object
    local room : Room = Room(
      prize=zero,
      entry_price=entry_price,
      game_name=game_name,
      winner_address=0,
      high_score=zero,  
      start_time=0,
      current_number_of_players=zero,
      has_started=0
      )

    # get the index free
    let (local room_index : Uint256) = game_to_room_ids.read(game_id=game_id, index=insertion_index)
    # increase index
    local one : Uint256 = Uint256(1, 0)
    let (local room_index_incrased) = uint256_checked_add(room_index, one)

    game_to_room_ids.write(game_id=game_id, index=insertion_index, value=room_index_incrased)

    # increase insertion_index
    let (local increased_insertion_index) = uint256_checked_add(insertion_index, one)

    game_to_room_ids_length.write(game_id=game_id, value=increased_insertion_index)

    tempvar syscall_ptr = syscall_ptr
    tempvar pedersen_ptr = pedersen_ptr
    tempvar range_check_ptr = range_check_ptr

    return (room_index_incrased) 
end   

###  
### PLAYERS
###

# function to create a new player account, only the owner can call this from the SC 
# on the frontend this request will need to be signed by the owner of the contract 
@external 
func create_player_accounts{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr,
    }(
        account : felt,
        username : felt 
    ):
    Ownable_only_owner()

    let player = Player(
        address=account,
        username=username,
        total_winnings=Uint256(0,0),
        amount_donated=Uint256(0,0)
    )

    # write the player to storage
    players.write(account=account, value=player)
    return () 
end 

# TODO 
# Allows a user to join a room 
@external
func player_join_room{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr,
    }(
        room_id : Uint256, 
        game_id : Uint256
    ) -> (success : felt):
    alloc_locals 

    with_attr error_message("game_id is not a valid uint256"):
        uint256_check(game_id)
    end 

    with_attr error_message("room_id is not a valid uint256"):
        uint256_check(room_id)
    end 
    # get the room object
    let (local room : Room) = rooms_mapping.read(room_id) 
    
    # 1. check if room has started
    with_attr error_message("You cannot join a room that has already started"):
        assert room.has_started = 0
    end         
    
  
    # 2. check if room has space
    local one : Uint256 = Uint256(1, 0) 
    let (local new_number_of_players) = uint256_checked_add(room.current_number_of_players, one)

    let (local game : Game) = games_mapping.read(game_id)
    with_attr error_message("The room has reached the max number of players"):
        uint256_le(new_number_of_players, game.game_max_players)
    end  

    # 3. pay fee (get it first)
    let (local token_address) = token_address_storage.read()
    let (local caller_address) = get_caller_address()
    let (local contract_address) = get_contract_address()
    let (local allowance : Uint256) = IERC20.allowance(
        contract_address=token_address, 
        owner=caller_address, 
        spender=contract_address)

    with_attr error_message("You need to approve the contract to spend your tokens"):
        uint256_le(allowance, game.entry_price)
    end 

    IERC20.transferFrom(
        contract_address=token_address, 
        sender=caller_address, 
        recipient=contract_address, 
        amount=game.entry_price
    )
    # 4. associate player - room 
    let (local insertion_index : Uint256) = players_to_room_length.read(caller_address)
    players_to_room.write(player_account=caller_address, index=insertion_index, value=room_id)
    let (local new_insertion_index : Uint256) = uint256_checked_add(insertion_index, one)
    players_to_room_length.write(player_account=caller_address, value=new_insertion_index)

    return (1)
end 


@external 
func start_room{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr,
    }(room_id : Uint256, game_id : Uint256) -> (success : felt):
    alloc_locals

    # uint256 checks 
    with_attr error_message("game_id is not a valid uint256"):
        uint256_check(game_id)
    end 

    with_attr error_message("room_id is not a valid uint256"):
        uint256_check(room_id)
    end 
    # check if room hasn't started already 
    let (local room : Room) = rooms_mapping.read(room_id) 
    
    # 1. check if room has started
    with_attr error_message("You cannot join a room that has already started"):
        assert room.has_started = 0
    end         
    
    # check that minimum number of player is there 
    let (local game : Game) = games_mapping.read(game_id=game_id)
    with_attr error_message("The minimum number of players has not been reached yet"):
        uint256_le(room.current_number_of_players, game.game_min_players)
    end 

    # set room started to 1 
    room.has_started=1
    rooms_mapping.write(room_id=room_id, value=room)

    return (1)
end     

@external 
func record_score { 
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr,
    } (
        player_account : felt, 
        score : Uint256, 
        room_id : Uint256 
    ):
    alloc_locals

    #Ownable_only_owner()

    let (local room : Room) = rooms_mapping.read(room_id)
    local new_room : Room = Room(
            prize=room.prize,
            entry_price=room.entry_price,
            game_name=room.game_name,
            winner_address=player_account,
            high_score=score,
            start_time=room.start_time,
            current_number_of_players=room.current_number_of_players,
            has_started=0
    )

    rooms_mapping.write(room_id, value=new_room)

    return () 
end 

# called by the owner 
@external 
func finish_room{ 
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr,
    } (room_id : Uint256):
    alloc_locals

    Ownable_only_owner()

    with_attr error_message("room_id is not a valid uint256"):
        uint256_check(room_id)
    end 

    let (local room : Room) = rooms_mapping.read(room_id)
    local new_room : Room = Room(
            prize=room.prize,
            entry_price=room.entry_price,
            game_name=room.game_name,
            winner_address=room.winner_address,
            high_score=room.high_score,
            start_time=room.start_time,
            current_number_of_players=room.current_number_of_players,
            has_started=0
    )

    rooms_mapping.write(room_id, value=new_room)

    return () 

end 

### 
### HELPERS 
### 

@external 
func send_to_charity{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr,
    }(
        charity_address : felt,
        donation : Uint256,
        donor_address : felt):
    alloc_locals 

    Ownable_only_owner()

    let (self_contract_address) = get_contract_address()
    let (token_address) = token_address_storage.read()
    let (contract_balance : Uint256) = IERC20.balanceOf(contract_address=token_address, account=self_contract_address)
    with_attr error_message("Not enough money to pay the charity, shame on you"):
        assert_lt(donation.low, contract_balance.low)
    end 

    IERC20.transferFrom(contract_address=charity_address, 
        sender=self_contract_address,
        recipient=charity_address,
        amount=donation)

    # update user donations

    let (player : Player) = players.read(donor_address)
    let (new_amount_donated) = uint256_checked_add(player.amount_donated, donation)
    let new_player : Player = Player(
        address=player.address,
        username=player.username,
        total_winnings=player.total_winnings,
        amount_donated=new_amount_donated
    )

    players.write(donor_address, value=new_player)

    return ()
end 

#will take an array of winners and an array of rewards and send the tokens 
@external 
func reward_tokens{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr,
    }(
        game_id : Uint256,
        room_id : Uint256
    ):
    alloc_locals

    # only the owner can do this  
    Ownable_only_owner()

    # prize 
    let (local room : Room) = rooms_mapping.read(room_id=room_id)
    let (local game : Game) = games_mapping.read(game_id=game_id)
    # calculate the total prize based on number of players and entry prize
    let (total_prize : Uint256) = uint256_checked_mul(room.current_number_of_players, game.entry_price)

    # get balance of the contract
    let (local self_contract_address) = get_contract_address()
    let (local token_address) = token_address_storage.read()
    let (local contract_balance : Uint256) = IERC20.balanceOf(contract_address=token_address, 
        account=self_contract_address)
    # check that the balance is higher than the reward money 
    let (local cmp) = uint256_le(total_prize, contract_balance)
    with_attr error_message("There are not enough funds in the contract to pay the winner, sorry"):
        assert cmp = 1
    end 

    let (local winner_prize : Uint256, house_prize : Uint256) = calculate_rewards(total_prize)

    # transfer 
    IERC20.transferFrom(
        contract_address=token_address, 
        sender=self_contract_address, 
        recipient=room.winner_address,
        amount=winner_prize)

    let (local player : Player) = players.read(room.winner_address)
    let (local total_win : Uint256) = uint256_checked_add(player.total_winnings, winner_prize)
    local updated_player : Player = Player(
        address=room.winner_address,
        username=player.username,
        total_winnings=total_win,
        amount_donated=Uint256(0, 0)
    )

    players.write(room.winner_address, updated_player)

    tempvar syscall_ptr = syscall_ptr
    tempvar pedersen_ptr = pedersen_ptr
    tempvar range_check_ptr = range_check_ptr

    return ()

end 

# internal function to calculate the rewards based on the total amout paid 
# 90% winner 10% house
func calculate_rewards{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr,
    }(total_amount : Uint256) -> (winner : Uint256, house : Uint256): 
    #(reward_len : felt, reward : felt*):
    alloc_locals

    # get the token address
    let (local token_address) = token_address_storage.read()
    local decimals = 18
    # let (local decimals) = IERC20.decimals(contract_address=token_address)
    let (local exponential) = pow(10, decimals)
    let (local total_amount_powered : Uint256) = uint256_checked_mul(total_amount, Uint256(exponential, 0))

    let (local divided_by_10 : Uint256, remainder : Uint256) = uint256_checked_div_rem(total_amount_powered, Uint256(10, 0))
    let (local winner_take_home : Uint256) = uint256_checked_mul(divided_by_10, Uint256(9, 0))
    let (local home_take_home : Uint256) = uint256_checked_sub_le(total_amount_powered, winner_take_home)
    return(winner_take_home, home_take_home)
end 


# internal function to get the entry fee for a game 
func get_fee_for_game{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr,
    } (game_id : Uint256) -> (fee : Uint256):

    alloc_locals 

    # get the game from game_id 
    let (local game : Game) = games_mapping.read(game_id=game_id)

    return (game.entry_price)
end 

# internal function to pay fee and verify that it was transferred 
func pay_fee_for_room{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr,
    } (
        amount : Uint256,
        room_id : Uint256,
        game_id : Uint256,
        caller_address : felt     
    ) -> (success : felt):
    alloc_locals 

    with_attr error_message("amount is not a valid uint256"):
        uint256_check(amount)
    end 

    with_attr error_message("room_id is not a valiud uint256"):
        uint256_check(room_id)
    end 

    with_attr error_message("game_id is not a valid uint256"):
        uint256_check(game_id)
    end 

    # get the ecosystem token 
    let (local token_address) = token_address_storage.read()

    # get contract address
    let (local contract_address) = get_contract_address()

    # allowance check 
    let (local allowance : Uint256) = IERC20.allowance(contract_address=token_address, owner=caller_address, spender=contract_address)
    
    # check if the balance of the caller is greater than the fee 
    let (local caller_balance : Uint256) = IERC20.balanceOf(contract_address=token_address, account=caller_address)

    # assert 
    let (local result) = uint256_lt(amount, caller_balance)
    with_attr error_message("Balance is less than the price of the game"):
        assert result = 1
    end 

    let (local result) = uint256_lt(amount, allowance)
    with_attr error_message("You should approve the contract to spend you tokens first"):
        assert result = 1
    end 

    # transfer the tokens 
    let (local success) = IERC20.transferFrom(
                            contract_address=token_address, 
                            sender=caller_address, 
                            recipient=contract_address, 
                            amount=amount
                            )    


    # revoked references
    tempvar syscall_ptr = syscall_ptr
    tempvar pedersen_ptr = pedersen_ptr
    tempvar range_check_ptr = range_check_ptr
    
    return (success)
end 

# function for owner to withdraw funds 
@external
func withdraw_funds{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr,
    }():
    alloc_locals 

    # check that we are the owners 
    Ownable_only_owner()
    # get the values we need: caller address, our contract address, and the address of the ecosystem token 
    let (local caller_address) = get_caller_address()
    let (local contract_address) = get_contract_address()
    let (local token_address) = token_address_storage.read()

    
    # get the total quantity of token held in the contract
    let balance : Uint256 = IERC20.balanceOf(contract_address=token_address, account=contract_address)

    # transfer the tokens 
    IERC20.transferFrom(contract_address=token_address, sender=contract_address, recipient=caller_address, amount=balance)

    return () 
end 


# VIEW FUNCTIONS 

## GAMES

# get a game information  
@view 
func get_game_information{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr,
    }(game_id : Uint256) -> (game : Game):

    let game : Game = games_mapping.read(game_id=game_id)

    return (game)
end 

# returns the number of games registered so far 
@view 
func get_number_of_games{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr,
    }() -> (number : felt):

    let number : Uint256 = game_id_counter.read()
    return (number.low)
end 

## ROOMS

@view 
func get_room_information{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr,
    } (room_id : Uint256) -> (room : Room):
    alloc_locals 

    let (local room : Room) = rooms_mapping.read(room_id=room_id)

    return (room)
end 


## PLAYERS 

@view 
func get_player_information{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr,
    }(address : felt) -> (player : Player):
    alloc_locals
    let (local player : Player) = players.read(address)
    return (player)
end 

## HELPERS 

# function to get the balance of the contract (could be useful to a frontend)
@view 
func get_contract_balance{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr,
    }() -> (balance : felt):

    alloc_locals 

    # get the stuff we need 
    let (local token_address) = token_address_storage.read()
    let (local contract_address) = get_contract_address()

    # get balance 
    let (local balance : Uint256) = IERC20.balanceOf(contract_address=token_address, account=contract_address)

    # return only low part 
    return (balance.low)
end 