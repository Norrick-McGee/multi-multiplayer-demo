@tool
extends CharacterBody3D

@export var idea_mesh: MeshInstance3D
@export var has_idea: bool:
	set(value):
		if idea_mesh != null:
			idea_mesh.visible = value
		has_idea = value
@export var character_name: String
@export var target: Node3D

func _ready():
	$"Smell-o-vision".connect("smell_entered", can_smell)
	$"Smell-o-vision".connect("smell_exited", cant_smell)


func can_smell():
	self.has_idea = true
func cant_smell():
	self.has_idea = false
func handle_grav() -> Vector3: 
	var gravitational_change_in_velocity: Vector3 = Vector3()
	if not is_on_floor():
		gravitational_change_in_velocity += get_gravity() 
	return gravitational_change_in_velocity


func rotate_towards_3D(target_pos: Vector3):
	var delta_vector: Vector3 = self.position - target.position
	# Consider making this calculation into a function in our GodotUtils, it's a shame something like this doesn't already exist, making me run such a calc in a scripting language rather than a compiled is just sad :( maybe they have some magic behind the scenes that makes this not taxing. But holy schmoly, this is gamedev, we don't want to be running expensive calcs in a scripting language, performance matters!!!!!!!
	var delta_angle_degrees: float = rad_to_deg(Vector2(delta_vector.x, delta_vector.z).angle()) 
	# delta_angle_degrees should tell you which direction you need to be pointing in order to look at someone
	self.global_rotation_degrees.y = delta_angle_degrees
	
func rotate_towards_target(target: Node3D, rotation_speed: float) -> float:
	var tv = Vector2(target.position.x, target.position.z)
	var angle_radians = tv.angle()
	var angle_degrees = rad_to_deg(angle_radians)
	
	# Normalize angles to the range [0, 360)
	var current_deg = fmod(self.rotation.y + 360, 360)
	var target_deg = fmod(angle_degrees + 360, 360)
	# Calculate the shortest rotation direction
	var delta = target_deg - current_deg
	if delta > 180:
		delta -= 360
	elif delta < -180:
		delta += 360
	
	var step: float
	step = rotation_speed * sign(delta)
	if abs(delta) <= rotation_speed:
		step = target_deg  # Snap to target if within step
	
	print("Current: {deg}".format({"deg":self.rotation.y}))
	print("Target: {deg}".format({"deg":angle_degrees}))
	print("Step: {deg}".format({"deg":step}))
	return step

func move_towards_target(target: Node3D) -> Vector3:
	return Vector3(0,0,0)


var rvelocity: Vector3 = Vector3() 
func _physics_process(delta):
	# Handle Gravity
	velocity += handle_grav() * delta
	#var rotation_step = rotate_towards_target(target, 5.5) * delta
	# rotate_y(rotation_step)
	rotate_towards_3D(target.position)
	velocity += move_towards_target(target) * delta
	move_and_slide()
