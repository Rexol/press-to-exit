extends Node3D


@onready var slot_door = $Walls/SlotDoor

var slot_available = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func show_end_screen():
	var end_screen = preload("res://scenes/Screens/EndScreen.tscn").instantiate()
	get_tree().current_scene.add_child(end_screen)


func _on_level_end_trigger_body_entered(body:Node3D) -> void:
	if body.is_in_group("cube"):
		show_end_screen()


func _on_open_slot_door_body_entered(body:Node3D) -> void:
	if body.is_in_group("cube"):
		if slot_available:
			slot_available = false
			slot_door.free()
