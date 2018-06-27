extends Node

#ToDo:	-implement mandatory jumps rule
#		-endgame
#			-check if player has pieces left
#			-check if player can move
#			-check for draw
#			-add offer draw button
#		-HUD
#			-start/restart game (temp reset button implemented)
#			-track captured pieces / score
#			-track current side
#		-other
#			-visual cue if move is valid
#			-sounds
#			-add variant rules

var menIsSelected = false
var mousePosition
var selectedMen
var menInTile = 0
var moveSuccess = false
var player_side = global.starting_side
var score_white = 0
var score_black = 0
var skipped = false
var boardSize
var whiteHasMoves = true
var blackHasMoves = true
var forcedJump = false

func _ready():
	boardSize = $Board.boardSize
	pass
	
func _process(delta):
	if menIsSelected:
		selectedMen.isSelected = true
	if moveSuccess:
		if player_side == "white":
			player_side = "black"
		else:
			player_side = "white"
		moveSuccess = false
		$Board.canSkip = false
		
		whiteHasMoves = false
		blackHasMoves = false
		forcedJump = false
		for x in $Board.grid:
			for tile in x:
				if typeof(tile) != typeof(0):
					if $Board.men_has_valid_moves(tile) and tile.side == "white":
						whiteHasMoves = true
					elif $Board.men_has_valid_moves(tile) and tile.side == "black":
						blackHasMoves = true
					if $Board.men_can_jump(tile) and tile.side == player_side:
						tile.mustJump = true
						forcedJump = true
					else:
						tile.mustJump = false
						tile.deselect()
	#check for winner/draw


func _input(event):
	""" 
	When clicking on a board space attempt to move a selected piece there
	Uses $Board.move_men to verify if the move is valid and to move the piece
	Right clicking deselects a men.
	"""
	if (event.is_pressed() and event.button_index == BUTTON_LEFT):
		mousePosition = $Board.world_to_map(event.position - $Board.position)
		menInTile = get_men(mousePosition)

		#click on a piece when no piece is selected
		if not menIsSelected and typeof(menInTile) != typeof(0):
			if menInTile.side == player_side:
				if not forcedJump or menInTile.mustJump:
					menIsSelected = true
					selectedMen = menInTile
					selectedMen.select()
			
		# deselect piece when clicking on it again
		elif menIsSelected and typeof(menInTile) != typeof(0):
			selectedMen.deselect() 
			selectedMen = 0
			menIsSelected = false
			if skipped:
				moveSuccess = true
				skipped = false

		#click on an empty space when a piece is selected
		elif menIsSelected and typeof(menInTile) == typeof(0):
			skipped = $Board.move_men(selectedMen, mousePosition)
			if mousePosition.y == 0 and selectedMen.side == "white" or mousePosition.y == 7 and selectedMen.side == "black":
				selectedMen.king()
				skipped = false
			if not skipped:
				selectedMen.deselect()
				selectedMen = 0
				menIsSelected = false

	#deselect a piece on right click
	if (event.is_pressed() and event.button_index == BUTTON_RIGHT):
		if typeof(selectedMen) != typeof(0):
			selectedMen.deselect() #this only removes the outline on the selected piece
			selectedMen = 0
			if skipped:
				moveSuccess = true
				skipped = false
		menIsSelected = false


func new_game():
	$Board.show()
	
func game_over():
	$Board.hide()
	
func get_men(boardPosition):
	if Rect2(Vector2(0,0), Vector2(boardSize,boardSize)).has_point(boardPosition):
		return $Board.grid[boardPosition.x][boardPosition.y]
	else:
		return 0


func _on_Reset_pressed():
	score_white = 0
	score_black = 0
	$Board.reset_board()

func _on_men_moved():
	moveSuccess = true
