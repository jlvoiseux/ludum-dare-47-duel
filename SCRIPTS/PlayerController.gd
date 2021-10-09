extends AnimatedSprite

var speed = 75
var dashMultiplicator = 5
var dashDuration = 0.1
var yInc = 0
var xInc = 0
var isDashing = false

var timer
var currGem = 1
var gem1
var gem2
var gem3
var line12
var line23
var line31
var animPlayer
var stopFrame = 0
var gemSound

var canMove = true
var initialFlag = false

var gm

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = get_node("Timer")
	timer.one_shot = true
	line12 = get_node("../Gems/Line12")
	line23 = get_node("../Gems/Line23")
	line31 = get_node("../Gems/Line31")
	gem1 = get_node("../Gems/Gem1")
	gem2 = get_node("../Gems/Gem2")
	gem3 = get_node("../Gems/Gem3")
	gemSound = get_node("../GemSound")
	gm = get_node("../..")
	animPlayer = get_node("AnimationPlayerMc")
	set_process(true)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	checkMovement(delta)
	
func checkMovement(delta):	
	if(canMove):
		if(!isDashing):
			yInc = 0
			xInc = 0
			if(Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_left")):
				yInc = -speed*delta
				xInc = -speed*delta
				set_flip_h(true)
				stopFrame = 4
				if(animPlayer.current_animation != "MC_Walk_Side"):
					animPlayer.play("MC_Walk_Side")
			elif(Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_right")):
				yInc = -speed*delta
				xInc = speed*delta
				set_flip_h(false)
				stopFrame = 4
				if(animPlayer.current_animation != "MC_Walk_Side"):
					animPlayer.play("MC_Walk_Side")
			elif(Input.is_action_pressed("ui_down") and Input.is_action_pressed("ui_left")):
				yInc = speed*delta
				xInc = -speed*delta
				set_flip_h(true)
				stopFrame = 4
				if(animPlayer.current_animation != "MC_Walk_Side"):
					animPlayer.play("MC_Walk_Side")
			elif(Input.is_action_pressed("ui_down") and Input.is_action_pressed("ui_right")):
				yInc = speed*delta
				xInc = speed*delta
				set_flip_h(false)
				stopFrame = 4
				if(animPlayer.current_animation != "MC_Walk_Side"):
					animPlayer.play("MC_Walk_Side")
			elif(Input.is_action_pressed("ui_up")):
				yInc = -speed*delta
				xInc = 0
				stopFrame = 0
				if(animPlayer.current_animation != "MC_Walk_Top"):
					animPlayer.play("MC_Walk_Top")
			elif(Input.is_action_pressed("ui_left")):
				yInc = 0
				xInc = -speed*delta
				set_flip_h(true)
				stopFrame = 4
				if(animPlayer.current_animation != "MC_Walk_Side"):
					animPlayer.play("MC_Walk_Side")
			elif(Input.is_action_pressed("ui_down")):
				yInc = speed*delta
				xInc = 0
				stopFrame = 2
				if(animPlayer.current_animation != "MC_Walk_Bottom"):
					animPlayer.stop()
					animPlayer.play("MC_Walk_Bottom")
			elif(Input.is_action_pressed("ui_right")):
				yInc = 0
				xInc = speed*delta
				set_flip_h(false)
				stopFrame = 4
				if(animPlayer.current_animation != "MC_Walk_Side"):
					animPlayer.play("MC_Walk_Side")
			else:
				frame = stopFrame
				animPlayer.stop()
					
			if(Input.is_action_just_pressed("ui_select")):
				isDashing = true
				yInc*=dashMultiplicator
				xInc*=dashMultiplicator
				timer.start(dashDuration)
		
		if(gm.state == 1):			
			if(position.y <= 32):
				if(yInc < 0):
					yInc = 0
			elif(position.y >= 156):
				if(yInc > 0):
					yInc = 0
		else:
			if(position.y >= -24):
				if(yInc > 0):
					yInc = 0
			elif(position.y <= -150):
				if(yInc < 0):
					yInc = 0
					
		if(position.x <= 24):
			if(xInc < 0):
				xInc = 0
		elif(position.x >= 297):
			if(xInc > 0):
				xInc = 0
					
		
		
		position.y += yInc
		position.x += xInc
		
	elif(!gm.hasDied):
		animPlayer.stop()

func _on_Timer_timeout():
	isDashing = false
	gemSound.play()
	if(gm.state == 1 or gm.boss.canMove):
		if(currGem == 1):
			gem1.position = position
			currGem = 2		
		elif(currGem == 2):
			gem2.position = position
			currGem = 3
		elif(currGem == 3):
			gem3.position = position
			currGem = 1
			initialFlag = true
		if(initialFlag):
			line12.set_points([gem1.position, gem2.position])
			line23.set_points([gem2.position, gem3.position])
			line31.set_points([gem3.position, gem1.position])
		
func die():
	animPlayer.play("Mc_Hit")






