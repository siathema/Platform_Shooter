extends KinematicBody2D

const GRAVITY = 1000.0
const WALK_SPEED = 60.0
const MAX_WALK_SPEED = 600.0
const JUMP_SPEED = 600.0

enum {
	ON_GROUND, FALLING, JUMPING, STANDING, WALKING_RIGHT, WALKING_LEFT
}

var velocity = Vector2()
var state = ON_GROUND

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	
	velocity.y += delta * GRAVITY
	
	if(Input.is_action_pressed("ui_up")):
		if(state != JUMPING and state != FALLING):
			state = JUMPING
	
	if(Input.is_action_pressed("ui_left")):
		if(velocity.x >= -MAX_WALK_SPEED):
			velocity.x += -WALK_SPEED;
	elif(Input.is_action_pressed("ui_right")):
		if(velocity.x <= MAX_WALK_SPEED):
			velocity.x += WALK_SPEED;
	else:
		if(state == ON_GROUND):
			velocity.x = 0
	
	# state machine stuff
	if(state == JUMPING): #Jumping code
		velocity.y -= JUMP_SPEED
		state = FALLING

	var motion = velocity * delta
	motion = move(motion)
	
	if(is_colliding()):
		state = ON_GROUND
		var n = get_collision_normal()
		motion = n.slide(motion)
		velocity = n.slide(velocity)
		move(motion)