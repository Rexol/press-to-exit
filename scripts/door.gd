extends StaticBody3D

@onready var animation_player = $AnimationPlayer

func open():
	animation_player.play("door_open")
