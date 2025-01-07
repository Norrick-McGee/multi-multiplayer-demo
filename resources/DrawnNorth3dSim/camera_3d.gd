extends Camera3D

# Speed variables for camera movement and rotation
@export var movement_speed: float = 5.0
@export var rotation_speed: float = 200.0

# Input mappings for controller
var analog_stick_deadzone: float = 0.2
var move_input: Vector2
var rotate_input: Vector2


func _process(delta):
	handle_dpad_movement(delta)
	handle_analog_rotation(delta)

# Handles movement using the D-pad
func handle_dpad_movement(delta: float):
	move_input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	move_input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	if move_input.length() > 0:
		move_input = move_input.normalized() * movement_speed * delta
		translate(Vector3(move_input.x, 0, move_input.y))

# Handles rotation using an analog stick
func handle_analog_rotation(delta: float):
	rotate_input.x = Input.get_action_strength("rotate_y") - Input.get_action_strength("rotate_x")
	rotate_input.y = Input.get_action_strength("look_y") - Input.get_action_strength("look_x")

	if rotate_input.length() > analog_stick_deadzone:
		rotate_input *= rotation_speed * delta
		rotate_y(deg_to_rad(-rotate_input.x))
		rotate_x(deg_to_rad(-rotate_input.y))
