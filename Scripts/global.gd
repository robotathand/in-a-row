extends Node
#Global

class GameSetup:
	var width: int = 15
	var height: int = 15
	var length: int = 5


class GameState:
	# 0 - N/A, -1 - Player A, +1 - Player B
	var game_state: Array[Array] = []
	var current_player: int = 0
	var winner: int = 0
	
	func set_game_state(current_game: GameSetup):
		var row: Array[int] = []
		for _w in current_game.width:
			row.append(0)
		for _h in current_game.height:
			game_state.append(row)
	
	func check_win(current_place: Vector2i):
		var a = current_place[2]
