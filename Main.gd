extends Node

#ToDo:	-kings
#		-endgame
#		-HUD
#			-start/restart game (temp reset button implemented)
#			-track captured pieces / score
#		-other
#			-visual cue if move is valid
#			-sounds

var menIsSelected = false
var mousePosition
var selectedMen
var menInTile = 0
var moveSuccess = false
var player_side = "white"
var score_white = 0
var score_black = 0
var skipped = false

func _ready():
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


func _input(event):
	""" 
	When clicking on a board space attempt to move a selected piece there
	Uses $Board.move_men to verify if the move is valid and to move the piece
	Right clicking deselects a men. The piece is still stored in selectedMen
	but it does nothing without the menIsSelected flag 
	"""
	if (event.is_pressed() and event.button_index == BUTTON_LEFT):
		mousePosition = $Board.world_to_map(event.position - $Board.position)
		menInTile = get_men(mousePosition)

		#click on a piece when no piece is selected
		if not menIsSelected and typeof(menInTile) != typeof(0):
			if menInTile.side == player_side:
				menIsSelected = true
				selectedMen = menInTile
			
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
	if Rect2(Vector2(0,0), Vector2(8,8)).has_point(boardPosition):
		return $Board.grid[boardPosition.x][boardPosition.y]
	else:
		return 0


func _on_Reset_pressed():
	score_white = 0
	score_black = 0
	$Board.reset_board()

func _on_men_moved():
	moveSuccess = true
