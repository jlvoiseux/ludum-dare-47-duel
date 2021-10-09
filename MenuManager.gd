extends Node2D


var state = 1
var htp
var cred
var cursor


# Called when the node enters the scene tree for the first time.
func _ready():
	htp = get_node("HowToPlay")
	cred = get_node("Credits")
	cursor = get_node("Sprite3")
	set_process(true)



func _process(delta):
	if(Input.is_action_just_pressed("ui_select")):
		if(state == 1):
			get_tree().change_scene("res://Game.tscn")
		elif(state == 2):
			htp.show()
			state = 4
		elif(state == 3):
			cred.show()
			state = 5
		elif(state == 4):
			htp.hide()
			state = 2
			cursor.position = Vector2(83, 116)
		elif(state == 5):
			cred.hide()
			state = 3
			cursor.position = Vector2(83, 142)
	elif(Input.is_action_just_pressed("ui_down")):
		if(state == 1):
			state = 2
			cursor.position = Vector2(83, 116)
		elif(state == 2):
			state = 3
			cursor.position = Vector2(83, 142)
	elif(Input.is_action_just_pressed("ui_up")):
		if(state == 2):
			state = 1
			cursor.position = Vector2(83, 91)
		elif(state == 3):
			state = 2
			cursor.position = Vector2(83, 116)
