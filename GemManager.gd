extends Node2D


var gem1
var gem2
var gem3
var line12
var line23
var line31
var anim

# Called when the node enters the scene tree for the first time.
func _ready():
	gem1 = get_node("Gem1")
	gem2 = get_node("Gem2")
	gem3 = get_node("Gem3")
	line12 = get_node("Line12")
	line23 = get_node("Line23")
	line31 = get_node("Line31")
	anim = get_node("AnimationPlayerGems")
	anim.play("GemIdlePurple")	

func showHit():
	anim.play("Hit")
	
func gemIdle():
	anim.play("GemIdlePurple")
