extends Node2D

var side = "white"
var blackSide = false; #false for white, true for black
var king = false;
var location
var isSelected = false
var mustJump = false
var whiteOutline = Color(0.2, 0.2, 0.9, 1.0)
var blackOutline = Color(0.6, 0.6, 0.9, 1.0)
var forcedWhiteOutline = Color(0.2, 0.8, 0.4, 1.0)
var forcedBlackOutline = Color(0.8, 0.4, 0.6, 1.0)
var mouseOver = false
var outlined = false
var currentColor


func _ready():
	#give each instance its own copy of material
	var mat = $Sprite.get_material().duplicate(true)
	$Sprite.set_material(mat)
	$Sprite.material.set_shader_param("outlineSize",0)
	
	if side == "black":
		$Sprite.frame = 0
		currentColor = blackOutline
	elif side == "white":
		$Sprite.frame = 1
		currentColor = whiteOutline
		
	$Sprite.material.set_shader_param("outlineColor", currentColor)

func _process(delta):
	if mustJump:
		outlined = true
		if side == "black":
			currentColor = forcedBlackOutline
		elif side == "white":
			currentColor = forcedWhiteOutline
	
	if mouseOver or isSelected:
		if side == "black":
			currentColor = blackOutline
		elif side == "white":
			currentColor = whiteOutline
	
	if outlined:
		if side == "black":
			$Sprite.material.set_shader_param("outlineSize",0.013)
		elif side == "white":
			$Sprite.material.set_shader_param("outlineSize",0.015)
	elif not outlined:
		$Sprite.material.set_shader_param("outlineSize", 0)
	$Sprite.material.set_shader_param("outlineColor", currentColor)


func _on_Men_mouse_entered():
	mouseOver = true
	outlined = true

func _on_Men_mouse_exited():
	mouseOver = false
	if not isSelected or not mustJump:
		outlined = false

func select():
	isSelected = true
	outlined = true

func deselect():
	isSelected = false
	outlined = false
	
func king():
	king = true
	if side == "black":
		$Sprite.frame = 2
	elif side == "white":
		$Sprite.frame = 3




