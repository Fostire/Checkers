extends TileMap


var grid = []
var halfTile = self.cell_size / 2
var mousePosition
var selectedMen
var menIsSelected = false
var startPositions = []


enum TILES {EMPTY, BLACK, WHITE, K_BLACK, K_WHITE} 

var men = preload("res://Men.tscn")

func _ready():
	set_starting_pos()
	for x in range(8):
		grid.append([])
		for y in range(8):
			grid[x].append(0)
	
	for pos in startPositions:
		var new_men = men.instance()
		new_men.position = map_to_world(pos) + halfTile
		if pos.y < 3:
			new_men.blackSide = true
			grid[pos.x][pos.y] = BLACK
		elif pos.y > 4:
			new_men.blackSide = false
			grid[pos.x][pos.y] = WHITE
		add_child(new_men)
		new_men.connect("clicked", get_parent(), "on_select_men")

func set_starting_pos():
	for y in range (8):
		if y in [3, 4]:
			continue
		for x in range (8):
			if y % 2 == 0 and x % 2 == 0:
					startPositions.append(Vector2(x, y))
			elif y % 2 != 0 and x % 2 != 0:
					startPositions.append(Vector2(x, y))


func move_men(selected, newPos):
	var currentTile = world_to_map(selected.position)
	var newTile = world_to_map(newPos)
	var success = false
	var newX = int(newTile.x)
	var newY = int(newTile.y)
	var oldX = currentTile.x
	var oldY = currentTile.y
	var moveVector = newTile - currentTile
	var skipX = oldX + (moveVector / 2).x
	var skipY = oldY + (moveVector / 2).y


	if newX < 0 or newX > 7 or newY < 0 or newY > 7:
		success = false
	#check if it's a red square:
	elif (newY % 2 == 0 and newX % 2 == 0) or (newY % 2 != 0 and newX % 2 != 0):
		
		#check if it's too far:
		if moveVector.abs() == Vector2(1,1):
			# 1-tile move
			# check if it's an empty square:
			if grid[newX][newY] == 0:
				selected.position = newPos
				grid[newX][newY] = grid[oldX][oldY]
				grid[oldX][oldY] = 0
				success = true
			else:
				success = false
		elif moveVector.abs() == Vector2(2,2):
			# 2-tile move
			# check if it's a valid skip:
			if grid[skipX][skipY] > 0 and grid[skipX][skipY] != grid[oldX][oldY]:
				selected.position = newPos
				grid[newX][newY] = grid[oldX][oldY]
				grid[oldX][oldY] = 0
				success = true
			else:
				success = false
		else:
			success = false
	else: 
		success = false

	return success #returns true if the move was played





	

