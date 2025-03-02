extends Node3D


@onready var slot_door = $Walls/SlotDoor
@onready var control_hint = $CanvasLayer/BasicControls
@onready var try_again_hint = $CanvasLayer/TryAgainHint
@onready var door = $Door

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	control_hint.visible = true  # Show at the start

func _input(event):
	if event.is_action_released("latter_button"):
		hide_message(control_hint)
		# print("Door position: x:%f y:%f z:%f" % [door.transform.position.x, door.transform.position.y, door.transform.position.z] )

func hide_message(label: Label):
	var tween = create_tween()
	tween.tween_property(label, "modulate:a", 0, 1.0)  # Fade out in 1 sec
	await tween.finished
	label.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func show_end_screen():
	var end_screen = preload("res://entities/ui/end_screen/EndScreen.tscn").instantiate()
	get_tree().current_scene.add_child(end_screen)


func _on_level_end_trigger_body_entered(body:Node3D) -> void:
	if body.is_in_group("cube"):
		show_end_screen()


func _on_open_slot_door_body_entered(body:Node3D) -> void:
	if body.is_in_group("cube"):
		if is_instance_valid(slot_door):
			try_again_hint.visible = true
			await get_tree().create_timer(1.5).timeout
			hide_message(try_again_hint)
			slot_door.free()
