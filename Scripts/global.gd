extends Node
#Global

class GameSetup:
	var width: int = 15
	var height: int = 15
	var length: int = 5
	# Could add number of lines later on


class GameState:
	# 0 - N/A, -1 - Player A, +1 - Player B
	var game_setup: GameSetup
	var game_state: Array[Array] = []
	var current_player: int = 0
	var winner: int = 0
	
	func _init():
		# Setup game_state array
		var row: Array[int] = []
		for _w in game_setup.width:
			row.append(0)
		for _h in game_setup.height:
			game_state.append(row)
	
	func check_win(current_place: Vector2i):
		var is_win: bool = false
		var current_x = current_place.x
		var current_y = current_place.y
		
		# Vertical
		var vertical_count = 0
		for up in range(game_setup.length):
			if current_y - up < 0:
				break
			else:
				if game_state[current_y - up][current_x] == current_player:
					vertical_count += 1
				else:
					break
		
		return is_win
