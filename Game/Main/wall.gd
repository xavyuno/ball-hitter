extends StaticBody2D

@export var Div := 1

func WallSpace():
	position.x = 640 + (32 * System.WallSpace) * Div

func _physics_process(delta: float) -> void:
	WallSpace()
	match Div:
		1:
			System.MaxX = position.x
		-1:
			System.MinX = position.x
