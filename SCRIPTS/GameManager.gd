extends Node2D


var state = 1
var gems
var gem1
var gem2
var gem3
var line12
var line23
var line31
var mc
var lever
var boss
var killer
var animPlayer
var mc_anim
var changeStateFlag = false
var hasDied = false
var hasWon = false
var gameover
var victory
var initPos
var initFrame
var initPosBoss
var initFrameBoss
var killSound
var theme

# Called when the node enters the scene tree for the first time.
func _ready():
	gems = get_node("Bg/Gems")
	gem1 = get_node("Bg/Gems/Gem1")
	gem2 = get_node("Bg/Gems/Gem2")
	gem3 = get_node("Bg/Gems/Gem3")
	line12 = get_node("Bg/Gems/Line12")
	line23 = get_node("Bg/Gems/Line23")
	line31 = get_node("Bg/Gems/Line31")
	killer = get_node("Bg/Boss/killer")
	mc = get_node("Bg/Mc")
	mc_anim = get_node("Bg/Mc/AnimationPlayerMc")
	lever = get_node("Bg/Lever")
	boss = get_node("Bg/Boss")
	animPlayer = get_node("AnimationPlayer")
	animPlayer.play("State1Idle")
	gameover = get_node("GameOver")
	victory = get_node("Victory")
	killSound = get_node("Bg/KillSound")
	theme = get_node("Bg/Theme")
	boss.canMove = false
	set_process(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(state == 0):
		if(Input.is_action_just_pressed("ui_r")):
			gameover.hide()
			state = 1
			mc.position = initPos
			mc.frame = initFrame
			boss.position = initPosBoss
			boss.frame = initFrameBoss
			nextStateBis()
	elif(hasWon):
		if(Input.is_action_just_pressed("ui_r")):
			get_tree().change_scene("res://Menu.tscn")
	else:
		checkKill()
		if(changeStateFlag):
			if(!animPlayer.is_playing()):
				if(hasDied):
					if(!mc_anim.is_playing()):
						gameover.show()
						state = 0
						hasDied = false
						changeStateFlag = false
				else:
					nextStateBis()
					changeStateFlag = false
		else:
			if(mc.initialFlag):
				checkHit()
	
func checkHit():
	if(state == 1):
		if(isInside(gem1.position.x, gem1.position.y, gem2.position.x, gem2.position.y, gem3.position.x, gem3.position.y, lever.position.x, lever.position.y)):
			killSound.play()
			nextState()
	elif(state == 2):
		if(isInside(gem1.position.x, gem1.position.y, gem2.position.x, gem2.position.y, gem3.position.x, gem3.position.y, boss.position.x, boss.position.y)):
			killSound.play()
			nextState()
	elif(state == 3):
		if(isInside(gem1.position.x, gem1.position.y, gem2.position.x, gem2.position.y, gem3.position.x, gem3.position.y, boss.position.x, boss.position.y)):
			killSound.play()
			nextState()
	elif(state == 4):
		if(isInside(gem1.position.x, gem1.position.y, gem2.position.x, gem2.position.y, gem3.position.x, gem3.position.y, boss.position.x, boss.position.y)):
			killSound.play()
			nextState()
			
func checkKill():
	if(killer.get_global_position().distance_to(mc.get_global_position()) < 8 and !hasDied and !mc.isDashing):
		hasDied = true
		mc.canMove = false
		boss.canMove = false
		boss.canDash = false
		mc.die()
		changeStateFlag = true;
			
func nextState():
	if(state == 1):
		mc.canMove = false
		mc.initialFlag = false
		gems.showHit()
		animPlayer.play("State1End")
		changeStateFlag = true
	elif(state == 2):		
		boss.canMove = false
		gems.showHit()
		animPlayer.play("BossHit")
		changeStateFlag = true
	elif(state == 3):		
		boss.canMove = false
		gems.showHit()
		animPlayer.play("BossHit")		
		changeStateFlag = true
	elif(state == 4):
		boss.canMove = false
		mc.canMove = false
		gem1.position = Vector2(-100, -100)
		gem2.position = Vector2(-100, -100)
		gem3.position = Vector2(-100, -100)
		line12.set_points([gem1.position, gem2.position])
		line23.set_points([gem2.position, gem3.position])
		line31.set_points([gem3.position, gem1.position])
		gems.gemIdle()
		animPlayer.play("BossDie")		
		changeStateFlag = true
		
func nextStateBis():
	if(state == 1):
		state = 2
		initPos = mc.position
		initFrame = mc.frame
		initPosBoss = boss.position
		initFrameBoss = boss.frame
		boss.canMove = true
		boss.canDash = false
		mc.canMove = true
		mc.initialFlag = false
		mc.currGem = 1
		gem1.position = Vector2(-100, -100)
		gem2.position = Vector2(-100, -100)
		gem3.position = Vector2(-100, -100)
		line12.set_points([gem1.position, gem2.position])
		line23.set_points([gem2.position, gem3.position])
		line31.set_points([gem3.position, gem1.position])
		gems.gemIdle()
		boss.speed = 40
		if(!theme.playing):
			theme.play()
	elif(state == 2):
		state = 3
		boss.canMove = true
		boss.canDash = false
		mc.initialFlag = false
		mc.currGem = 1
		gem1.position = Vector2(-100, -100)
		gem2.position = Vector2(-100, -100)
		gem3.position = Vector2(-100, -100)
		line12.set_points([gem1.position, gem2.position])
		line23.set_points([gem2.position, gem3.position])
		line31.set_points([gem3.position, gem1.position])
		gems.gemIdle()
		boss.speed = 75
	elif(state == 3):
		state = 4
		boss.canMove = true
		boss.canDash = true
		mc.initialFlag = false
		mc.currGem = 1
		gem1.position = Vector2(-100, -100)
		gem2.position = Vector2(-100, -100)
		gem3.position = Vector2(-100, -100)
		line12.set_points([gem1.position, gem2.position])
		line23.set_points([gem2.position, gem3.position])
		line31.set_points([gem3.position, gem1.position])
		gems.gemIdle()
	elif(state == 4):
		mc.canMove = false
		boss.canMove = false
		boss.canDash = false
		hasWon = true
		victory.show()
		
func area(x1, y1, x2, y2, x3, y3):   
	return abs((x1 * (y2 - y3) + x2 * (y3 - y1) + x3 * (y1 - y2)) / 2.0)

# A function to check whether point P(x, y) 
# lies inside the triangle formed by  
# A(x1, y1), B(x2, y2) and C(x3, y3)  
func isInside(x1, y1, x2, y2, x3, y3, x, y):   
	# Calculate area of triangle ABC 
	var A = area (x1, y1, x2, y2, x3, y3)   
	# Calculate area of triangle PBC  
	var A1 = area (x, y, x2, y2, x3, y3) 	  
	# Calculate area of triangle PAC  
	var A2 = area (x1, y1, x, y, x3, y3) 	  
	# Calculate area of triangle PAB  
	var A3 = area (x1, y1, x2, y2, x, y) 	  
	# Check if sum of A1, A2 and A3  
	# is same as A 
	if(A == A1 + A2 + A3): 
		return true
	else: 
		return false
