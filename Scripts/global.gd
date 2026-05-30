# global state
extends Node

# game settings with the default being Gomoku
class GameSetup:
	var width: int = 15
	var height: int = 15
	var length: int = 5
	# could add number of lines needed later on to make the game harder


# can store the current of a game
class GameState:
	# 0 - N/A, -1 - Player A, +1 - Player B
	var game_setup: GameSetup # holds the game settings used for the current game
	var game_state: Array[Array] = [] # 2d array of integers indicating the counter on that spot
	var current_player: int = 0
	
	func _init():
		# setup game_state array
		var row: Array[int] = []
		for _w in game_setup.width:
			row.append(0)
		for _h in game_setup.height:
			game_state.append(row)
	
	
	func total_counters_one_direction(change_x: int, change_y: int, current_place: Vector2i) -> int:
		var count = 0
		var current_x = current_place.x
		var current_y = current_place.y
		
		for place in range(game_setup.length):
			current_x += change_x
			current_y += change_y
			if 0 <= current_x < game_setup.width and 0 <= current_y < game_setup.height:
				if game_state[current_y][current_x] == current_player:
					count += 1
				else:
					break
			else:
				break
		
		return count
	
	
	func check_win(current_place: Vector2i) -> bool:
		# totals the number of counters in each direction
		var vertical_count: int = (total_counters_one_direction(+1, 0, current_place)
				+ total_counters_one_direction(-1, 0, current_place) + 1)
		var horizontal_count: int = (total_counters_one_direction(0, +1, current_place)
				+ total_counters_one_direction(0, -1, current_place) + 1)
		var diagonal_count: int = (total_counters_one_direction(-1, +1, current_place)
				+ total_counters_one_direction(+1, -1, current_place) + 1)
		var antidiagonal_count: int = (total_counters_one_direction(+1, +1, current_place)
				+ total_counters_one_direction(-1, -1, current_place) + 1)
		
		# check if enough counters are present in any direction to constitute a win
		return true if (vertical_count == game_setup.length or horizontal_count == game_setup.length
				or diagonal_count == game_setup.length or antidiagonal_count == game_setup.length) \
				else false
