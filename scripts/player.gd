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
var rotation_direction = 1  # 1 - clockwise, -1 - counterclockwise


func _input(event):
	if moving:
		move_direction = Vector3.ZERO
		moving = false

	if event.is_action_pressed("latter_button"):
		selecting_direction = true
		ring.visible = true
		arrow.visible = true
		anim_player.play("press_feedback")

	elif event.is_action_released("latter_button"):
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

	if moving:
		velocity = move_direction * move_speed
		move_and_slide()
		
		if global_transform.origin.distance_to(start_position) >= travel_distance:
			moving=false
			velocity=Vector3.ZERO
