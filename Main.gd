extends Node

#ToDo: 	-capturing pieces
#			-moving after capturing
#		-turns
#		-kings
#		-endgame
#		-HUD
#			-start/restart game
#			-track captured pieces
#		-other visuals
#			-visual cue if move is valid

var menIsSelected = false
var newPos
var mousePosition
var selectedMen
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
		mousePosition = get_viewport().get_mouse_position()
		if menIsSelected:
			newPos = $Board.map_to_world($Board.world_to_map(event.position - $Board.position)) + $Board.halfTile
			# this finds the center of the tile where the mouse clicked
			# event.position - $Board.position : finds where the mouse clicked in relation to the board
			# then world_to_map finds which tile is there in the tilemap
			# then map_to_world finds the global position of the upper left corner of the tile
			# finally,  adding Board.halftile finds the center position of the tile
			
			moveSuccess = $Board.call_deferred("move_men", selectedMen, newPos)
			selectedMen.deselect()
		menIsSelected = false
		
	if (event.is_pressed() and event.button_index == BUTTON_RIGHT):
		menIsSelected = false
		selectedMen.deselect() #this only removes the outline on the selected piece

func on_select_men(selected):
	#connected from men signal. selected is a reference to an instance of men
	selectedMen = selected
	menIsSelected = true

func new_game():
	$Board.show()
	
func game_over():
	$Board.hide()