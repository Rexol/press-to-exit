extends Node3D

signal open_door

@export var required_hold_time: float = 2.0
@export var double_tap_time: float = 0.3

var progress_timer: float = 0.0
var player_inside = false
var original_scale: Vector3
var last_press_time: float = -1.0

@onready var progress_bar = $ProgressBar
@onready var area = $Area3D

func _ready():
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("cube"):  # Make sure cube is in "cube" group
		player_inside = true
		original_scale = body.scale  # Store original scale
		body.scale *= 0.9  # Shrink the cube to 90%

		# Preserve Y position while aligning X and Z to the slot
		var new_position = body.global_transform.origin
		new_position.x = global_transform.origin.x
		new_position.z = global_transform.origin.z
		body.global_transform.origin = new_position  # Apply position correction

		# Stop cube movement (assuming cube has a method for this)
		if body.has_method("lock_movement"):
			body.lock_movement(true)

func _on_body_exited(body):
	if body.is_in_group("cube"):
		reset_cube(body)
		
	progress_bar.visible = false

func reset_cube(body):
	var current_position = body.global_transform.origin  # Get current position
	var fixed_y = current_position.y  # Store the Y position to keep it consistent
	
	player_inside = false
	progress_timer = 0.0
	progress_bar.value = 0

	# Reset cube scale
	body.scale = original_scale

	# Unlock movement
	if body.has_method("lock_movement"):
		body.lock_movement(false)
	
	# Keep the cube on the same plane
	var new_position = body.global_transform.origin
	new_position.y = fixed_y  # Maintain Y position
	body.global_transform.origin = new_position

func _process(delta):
	if player_inside:
		if Input.is_action_just_pressed("latter_button"):
			var current_time = Time.get_ticks_msec() / 1000.0
			if last_press_time > 0 and (current_time - last_press_time) <= double_tap_time:
				reset_cube(get_tree().get_nodes_in_group("cube")[0])
			last_press_time = current_time
		if Input.is_action_pressed("latter_button"):
			progress_timer += delta
			progress_bar.value = (progress_timer / required_hold_time) * 100
			if progress_timer >= required_hold_time:
				emit_signal("open_door")
		elif player_inside and Input.is_action_just_released("latter_button"):
			progress_timer = 0.0
			progress_bar.value = 0
