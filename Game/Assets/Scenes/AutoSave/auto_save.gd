extends Timer

func _on_timeout() -> void:
	Save.SaveData()
