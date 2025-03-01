extends Control

@onready var fade_overlay = $FadeOverlay
@onready var restart_button = $VBoxContainer/RestartButton

func _ready():
    fade_overlay.modulate.a = 0  # Ensure it starts transparent
    start_fade_in()


func start_fade_in():
    var tween = create_tween()
    tween.tween_property(fade_overlay, "modulate:a", 1.0, 2.0)  # Fade-in over 2 sec

func _on_restart_button_pressed():
    get_tree().reload_current_scene()
