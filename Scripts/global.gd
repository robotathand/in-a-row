# global state
extends Node

# game settings with the default being Gomoku
class GameSetup:
	var width: int = 15
	var height: int = 15
	var length: int = 5
	# could add number of lines needed later on to make the game harder
	# could add number of players later on


class Move:
	var player: int = 0
	var location: Vector2i


	func _init(move):
		player = move.player
		location = move.location


# can store the current of a game
class GameState:
	# 0 - N/A, -1 - Player A, +1 - Player B
	var game_setup: GameSetup = GameSetup.new() # holds the game settings used for the current game
	var game_state: Array[Array] = [] # 2d array of integers indicating the counter on that spot
	var previous_moves_list: Array[Move] = []
	var redo_moves_list: Array[Move] = []
	var number_of_moves: int = 0
	var current_player: int = -1
	var game_state_before_reset: GameState = GameState.new()
	# BUG ^ causes infinite repetition


	func _init(chosen_game_setup: GameSetup = game_setup):
		# setup game_state array
		var row: Array[int] = []
		for _w in game_setup.width:
			row.append(0)
		for _h in game_setup.height:
			game_state.append(row)
			# BUG ^ appends exact same row object as each column

		game_setup = chosen_game_setup
		# BUG the bad ordering ^ will setup the wrong game


	## playing moves

	# currently only made for 2 players
	func next_player(_direction: int = +1):
		current_player *= -1


	func play_move(move: Move):
		game_state[move.location.y][move.location.x] = current_player
		previous_moves_list.append(Move.new(move))

		# clear future moves
		if redo_moves_list != []:
			redo_moves_list.clear()

		number_of_moves += 1
		next_player(+1)
		# BUG? ^ does not check for a win (put it before next_player, or pass checking argument)


	## undo/redo moves

	# undoos moves, usually 1
	func undo_moves(number_of_undos: int = 1):
		for _undo_number in range(number_of_undos):
			if not previous_moves_list.is_empty():
				var previous_move: Move = previous_moves_list.pop_back()
				game_state[previous_move.location.y][previous_move.location.x] = 0
				number_of_moves -= 1
				next_player(-1)
			else:
				break


	# redoos moves, usually 1
	func redo_moves(number_of_redos: int = 1):
		for _redo_number in range(number_of_redos):
			if not redo_moves_list.is_empty():
				var redo_move: Move = redo_moves_list.pop_back()
				if redo_move.player != 0:
					game_state[redo_move.location.y][redo_move.location.x] = redo_move.player
				else:
					# fallback only works for 2 player games
					game_state[redo_move.location.y][redo_move.location.x] = current_player * -1
					# BUG ^ may add as the wrong player
			number_of_moves += 1
			next_player(+1)


	## reset current game

	func reset_game_state():
		game_state_before_reset = self
		# BUG ^ references the current object; not a copy
		game_setup = game_setup
		# BUG is ^ a typo
		game_state.clear()
		previous_moves_list.clear()
		redo_moves_list.clear()
		number_of_moves = 0
		current_player = -1


	## checking for a win

	# to be called from check_win
	func total_counters_one_direction(change_x: int, change_y: int, checking_place: Vector2i, checking_player: int) -> int:
		var count = 0
		var current_x = checking_place.x
		var current_y = checking_place.y

		for place in range(game_setup.length):
			current_x += change_x
			current_y += change_y
			if 0 <= current_x < game_setup.width and 0 <= current_y < game_setup.height:
				if game_state[current_y][current_x] == checking_player:
					count += 1
				else:
					break
			else:
				break

		return count


	func check_win(checking_place: Vector2i, checking_player: int = current_player) -> bool:
		# totals the number of counters in each direction
		var vertical_count: int = (total_counters_one_direction(+1, 0, checking_place, checking_player)
				+ total_counters_one_direction(-1, 0, checking_place, checking_player) + 1)
		var horizontal_count: int = (total_counters_one_direction(0, +1, checking_place, checking_player)
				+ total_counters_one_direction(0, -1, checking_place, checking_player) + 1)
		var diagonal_count: int = (total_counters_one_direction(-1, +1, checking_place, checking_player)
				+ total_counters_one_direction(+1, -1, checking_place, checking_player) + 1)
		var antidiagonal_count: int = (total_counters_one_direction(+1, +1, checking_place, checking_player)
				+ total_counters_one_direction(-1, -1, checking_place, checking_player) + 1)

		# check if enough counters are present in any direction to constitute a win
		return true if (vertical_count == game_setup.length or horizontal_count == game_setup.length
				or diagonal_count == game_setup.length or antidiagonal_count == game_setup.length) \
		else false
