extends Node

#ToDo: 	-capturing pieces
#			-moving after capturing
#		-turns
#		-kings
#		-endgame
#		-HUD
#			-start/restart game
#			-track captured pieces
#		-other
#			-visual cue if move is valid
#			-sounds

var menIsSelected = false
var mousePosition
var selectedMen
var menInTile = 0
var moveSuccess

func _ready():
	pass
	
func _process(delta):
	if menIsSelected:
		selectedMen.isSelected = true
#	if moveSuccess:
#		endturn()


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
			menIsSelected = true
			selectedMen = menInTile

		#click on an empty space when a piece is selected
		elif menIsSelected and typeof(menInTile) == typeof(0):
			moveSuccess = $Board.call_deferred("move_men", selectedMen, mousePosition)
			selectedMen.deselect()
			selectedMen = 0
			menIsSelected = false

	#deselect a piece on right click
	if (event.is_pressed() and event.button_index == BUTTON_RIGHT):
		if typeof(selectedMen) != typeof(0):
			selectedMen.deselect() #this only removes the outline on the selected piece
			selectedMen = 0
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
	$Board.reset_board()
