extends CharacterBody3D

@export var move_speed = 4.0
@export var rotation_speed = 3.0
@export var travel_distance = 3.0

@onready var arrow_pivot = $ArrowPivot
@onready var arrow = $ArrowPivot/DirectionArrow
@onready var ring = $ArrowPivot/DirectionRing
@onready var anim_player = $AnimationPlayer

var move_direction = Vector3.ZERO
var selecting_direction = false
var moving = false
var start_position = Vector3.ZERO
var rotation_direction = -1  # 1 - clockwise, -1 - counterclockwise
var locked = false
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _input(event):
	if event.is_action_pressed("latter_button"):
		if moving:
			move_direction = Vector3.ZERO
			moving = false

		anim_player.play("press_feedback")
		if locked:
			return
		selecting_direction = true
		ring.visible = true
		arrow.visible = true

	elif event.is_action_released("latter_button"):
		anim_player.play("release_feedback")
		if locked:
			return
		selecting_direction = false
		ring.visible = false
		arrow.visible = false
		
		#Capture the movement direction from the arrow
		move_direction = arrow_pivot.global_transform.basis.z.normalized()
		start_position = global_transform.origin
		moving = true
		
		# Toggle rotation direction for next selection phase
		rotation_direction *= -1

func _physics_process(delta: float) -> void:
	if selecting_direction:
		arrow_pivot.rotate_y(rotation_speed * delta * rotation_direction)

	if is_on_floor():
		velocity.y = 0
	else:
		velocity.y -= gravity * delta

	if moving:
		velocity.x = move_direction.x * move_speed
		velocity.z = move_direction.z * move_speed
		move_and_slide()
		
		if global_transform.origin.distance_to(start_position) >= travel_distance:
			moving=false
			velocity=Vector3.ZERO

func lock_movement(val: bool):
	moving=false
	velocity=Vector3.ZERO
	locked=val
