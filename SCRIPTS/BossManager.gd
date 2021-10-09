extends AnimatedSprite

var speed = 40
var dashMultiplicator = 3.75
var dashDuration = 0.075
var yInc = 0
var xInc = 0
var isDashing = false

var timer
var timer2
var animPlayer
var stopFrame = 0

var mc

var canMove = true
var initialFlag = false
var canDash = false

var gm
var killer

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = get_node("Timer")
	timer2 = get_node("Timer2")
	killer = get_node("killer")
	timer.one_shot = true
	timer2.one_shot = true
	gm = get_node("../..")
	animPlayer = get_node("AnimationPlayerBoss")
	mc = get_node("../Mc")
	set_process(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	checkMovement(delta)
	
func checkMovement(delta):
	if(canMove):
		if(!isDashing):
			yInc = 0
			xInc = 0
			if(mc.position.y < position.y and mc.position.x < position.x):
				yInc = -speed*delta
				xInc = -speed*delta
				set_flip_h(true)
				frame = 4
				killer.position = Vector2(-15, 6)
			elif(mc.position.y < position.y and mc.position.x > position.x):
				yInc = -speed*delta
				xInc = speed*delta
				set_flip_h(false)
				frame = 4
				killer.position = Vector2(15, 6)
			elif(mc.position.y > position.y and mc.position.x < position.x):
				yInc = speed*delta
				xInc = -speed*delta
				set_flip_h(true)
				frame = 4
				killer.position = Vector2(-15, 6)
			elif(mc.position.y > position.y and mc.position.x > position.x):
				yInc = speed*delta
				xInc = speed*delta
				set_flip_h(false)
				frame = 4
				killer.position = Vector2(15, 6)
			elif(mc.position.y < position.y):
				yInc = -speed*delta
				xInc = 0
				frame = 0
				killer.position = Vector2(-6, -15)
			elif(mc.position.x < position.x):
				yInc = 0
				xInc = -speed*delta
				set_flip_h(true)
				frame = 4
				killer.position = Vector2(-15, 6)
			elif(mc.position.y > position.y):
				yInc = speed*delta
				xInc = 0
				frame = 2
				killer.position = Vector2(-6, 15)
			elif(mc.position.x > position.x):
				yInc = 0
				xInc = speed*delta
				set_flip_h(false)
				frame = 4
				killer.position = Vector2(20, 6)
					
		if(gm.state == 1):			
			if(position.y <= 32):
				if(yInc < 0):
					yInc = 0
			elif(position.y >= 156):
				if(yInc > 0):
					yInc = 0
		else:
			if(position.y >= -16):
				if(yInc > 0):
					yInc = 0
			elif(position.y <= -156):
				if(yInc < 0):
					yInc = 0
					
		if(position.x <= 24):
			if(xInc < 0):
				xInc = 0
		elif(position.x >= 297):
			if(xInc > 0):
				xInc = 0
				
		if(canDash):
			canDash = false
			isDashing = true
			yInc*=dashMultiplicator
			xInc*=dashMultiplicator
			timer.start(dashDuration)
		
		position.y += yInc
		position.x += xInc
		
	else:
		animPlayer.stop()

func _on_Timer_timeout():
	isDashing = false
	timer2.start(1)

func _on_Timer2_timeout():
	canDash = true
