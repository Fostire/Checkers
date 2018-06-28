extends CanvasLayer

signal reset_game

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func update_score(whiteScore, blackScore):
	$WhiteScore.text = str(whiteScore)
	$BlackScore.text = str(blackScore)

func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()



func _on_ResetButton_pressed():
	emit_signal("reset_game")


func _on_MessageTimer_timeout():
	$MessageLabel.hide()
