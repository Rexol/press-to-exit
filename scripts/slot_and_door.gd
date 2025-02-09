extends Node3D

@onready var slot = $InteractionSlot
@onready var door = $Door

func _ready():
	# Connect the slot's "open_door" signal to the door's "open" function
	if slot.has_signal("open_door"):
		slot.open_door.connect(door.open)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
