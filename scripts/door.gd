extends StaticBody3D

@onready var animation_player = $AnimationPlayer
var door_closed = true

func trigger():
	if door_closed:
		animation_player.play("door_open")
	else:
		animation_player.play_backwards("door_open")

	door_closed = !door_closed
