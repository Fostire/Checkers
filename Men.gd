extends Node2D

var blackSide = false; #false for white, true for black
var king = false;
signal clicked
var location
var isSelected = false


func _ready():
	#give each instance its own copy of material
	var mat = $Sprite.get_material().duplicate(true)
	$Sprite.set_material(mat)
	$Sprite.material.set_shader_param("outlineSize",0)
	
	if blackSide == true:
		$Sprite.frame = 0
		$Sprite.material.set_shader_param("outlineColor",Color(0.6, 0.6, 0.9, 1.0))
	else:
		$Sprite.frame = 1
		$Sprite.material.set_shader_param("outlineColor",Color(0.2, 0.2, 0.9, 1.0))


func _on_Men_mouse_entered():
	if not isSelected:
		$Sprite.material.set_shader_param("outlineSize",0.013)
		if not blackSide:
			$Sprite.material.set_shader_param("outlineSize",0.015)


func _on_Men_mouse_exited():
	if not isSelected:
		$Sprite.material.set_shader_param("outlineSize",0)

func deselect():
	isSelected = false
	$Sprite.material.set_shader_param("outlineSize",0)

func _on_Men_input_event(viewport, event, shape_idx):
	if (event.is_pressed() and event.button_index == BUTTON_LEFT):
		if not get_parent().get_parent().menIsSelected:
			emit_signal("clicked", self)




