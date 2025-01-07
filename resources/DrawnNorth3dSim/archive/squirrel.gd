extends CharacterBody3D


const SPEED = 1.0
const JUMP_VELOCITY = 1.5
var dir: Vector3 = Vector3(0,0,1) 


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()
