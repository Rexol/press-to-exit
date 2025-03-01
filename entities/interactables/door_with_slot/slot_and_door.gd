extends Node3D

@onready var slot = $InteractionSlot
@onready var door = $Door

func _ready():
	# Connect the slot's "open_door" signal to the door's "open" function
	if slot.has_signal("trigger"):
		slot.trigger.connect(door.trigger)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
