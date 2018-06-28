extends Node

#ToDo:	-endgame
#			-check if player has pieces left (done)
#			-check if player can move (done)
#			-check for draw (done)
#			-add offer draw button
#		-HUD
#			-start/restart game (temp reset button implemented)
#			-track captured pieces / score (done)
#			-track current side
#		-other
#			-visual cue if move is valid
#			-sounds
#			-add variant rules

var menIsSelected
var mousePosition
var selectedMen
var menInTile
var moveSuccess
var player_side
var score_white
var score_black
var skipped
var boardSize
var whiteHasMoves
var blackHasMoves
var forcedJump

func _ready():
	menIsSelected = false
	moveSuccess = false
	skipped = false
	whiteHasMoves = true
	blackHasMoves = true
	forcedJump = false
	menInTile = 0
	score_white = 0
	score_black = 0
	player_side = global.starting_side
	boardSize = $Board.boardSize
	$HUD.update_score(score_white, score_black)

	
func _process(delta):
	if menIsSelected:
		selectedMen.isSelected = true
	if moveSuccess:
		$HUD.update_score(score_white, score_black)
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
		if not whiteHasMoves and not blackHasMoves:
			$Board.clear_board()
			$HUD.show_message("Draw")
			reset_game()
		elif not whiteHasMoves:
			$Board.clear_board()
			$HUD.show_message("Black wins!")
			reset_game()
		elif not blackHasMoves:
			$Board.clear_board()
			$HUD.show_message("White wins!")
			reset_game()


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
			if moveSuccess or skipped:
				if mousePosition.y == 0 and selectedMen.side == "white" or mousePosition.y == 7 and selectedMen.side == "black":
					selectedMen.king()
					skipped = false
					moveSuccess = true
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


func reset_game():
	$Board.reset_board()
	menIsSelected = false
	moveSuccess = false
	skipped = false
	whiteHasMoves = true
	blackHasMoves = true
	forcedJump = false
	menInTile = 0
	score_white = 0
	score_black = 0
	$HUD.update_score(score_white, score_black)
	player_side = global.starting_side

func _on_men_moved():
	moveSuccess = true


func _on_HUD_reset_game():
	reset_game()
