extends Timer

@export var Random := false
@export var MinT := 0.5
@export var MaxT := 1.0

func _ready() -> void:
	if Random:
		wait_time = randf_range(MinT, MaxT)
	start()

func _on_timeout() -> void:
	if get_parent().is_in_group("Ball"):
		if get_parent().CanCollect:
			User.RoundStats["Balls"] += 1
	get_parent().queue_free()
