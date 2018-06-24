extends TileMap


var grid = []
var halfTile = self.cell_size / 2
var mousePosition
var selectedMen
var menIsSelected = false
var startPositions = []
var men = preload("res://Men.tscn")
var canSkip = false
signal moved

func _ready():
	new_board()
	set_up_board()

func new_board():
	for x in range(8):
		grid.append([])
		for y in range(8):
			grid[x].append(0)
			if y in [3, 4]:
				continue
			else:
				if y % 2 == 0 and x % 2 == 0:
					startPositions.append(Vector2(x, y))
				elif y % 2 != 0 and x % 2 != 0:
					startPositions.append(Vector2(x, y))

func set_up_board():
	for pos in startPositions:
		var new_men = men.instance()
		new_men.position = map_to_world(pos) + halfTile
		if pos.y < 3:
			new_men.side = "black"
			grid[pos.x][pos.y] = new_men
		elif pos.y > 4:
			new_men.side = "white"
			grid[pos.x][pos.y] = new_men
		add_child(new_men)

func clear_board():
	for child in self.get_children():
		if child.has_method("deselect"):
			child.queue_free()
	for x in range(8):
		for y in range(8):
			grid[x][y] = 0

func reset_board():
	clear_board()
	set_up_board()

func valid_skip(currentTile, moveVector):
	var oldX = currentTile.x
	var oldY = currentTile.y
	var skipX = oldX + (moveVector / 2).x
	var skipY = oldY + (moveVector / 2).y
	var valid = false
	var newTile = currentTile + moveVector
	var newX = newTile.x
	var newY = newTile.y
	
	if Rect2(Vector2(0,0), Vector2(8,8)).has_point(newTile):
		if typeof(grid[newX][newY]) == typeof(0) and typeof(grid[skipX][skipY]) != typeof(0): #skip position is not empty
			if grid[skipX][skipY].side != grid[oldX][oldY].side:
				valid = true
	
	return valid

func move_men(selected, newTile):
	var currentTile = world_to_map(selected.position)
	var skipped = false
	var newX = int(newTile.x)
	var newY = int(newTile.y)
	var oldX = currentTile.x
	var oldY = currentTile.y
	var moveVector = newTile - currentTile
	var skipX = oldX + (moveVector / 2).x
	var skipY = oldY + (moveVector / 2).y


	#check if it's in the board
	if Rect2(Vector2(0,0), Vector2(8,8)).has_point(newTile):
		#check if it's a red square:
		if (newY % 2 == 0 and newX % 2 == 0) or (newY % 2 != 0 and newX % 2 != 0):
			#check how much it's moving:
			if moveVector.abs() == Vector2(1,1) and not canSkip:
				# 1-tile move
				# check if it's an empty square:
				if grid[newX][newY] == 0:
					selected.position = map_to_world(newTile) + halfTile
					grid[newX][newY] = grid[oldX][oldY]
					grid[oldX][oldY] = 0
					emit_signal("moved")
	
			elif moveVector.abs() == Vector2(2,2):
				# 2-tile move
				# check if it's a valid skip:
				if valid_skip(currentTile, moveVector):
					# move and capture:
					selected.position = map_to_world(newTile) + halfTile
					grid[newX][newY] = grid[oldX][oldY]
					grid[oldX][oldY] = 0
					grid[skipX][skipY].queue_free()
					grid[skipX][skipY] = 0
					currentTile = newTile
					canSkip = false
					for x in [-2, 2]:
						for y in [-2, 2]:
							if valid_skip(currentTile, Vector2(x, y)):
								print("here")
								canSkip = true
					if not canSkip:
						emit_signal("moved")


	return canSkip #returns true if a piece was captured




	

