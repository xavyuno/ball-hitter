extends Area2D

@onready var refresh: Timer = $Refresh
@onready var close: Timer = $Close
@onready var Collision: CollisionShape2D = $Collision
@onready var Icon: Polygon2D = $Icon

var Size := 1

func _ready() -> void:
	Size = 64 * User.RoundPowers["Explode"]
	Collision.scale =  Vector2(Size/64, Size/64)
	Icon.scale = Vector2(Size/64, Size/64)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Block"):
		body.get_parent().DealDamage(User.RoundStats["Damage"] * System.Multiplier * (User.RoundPowers["Explode"] * 0.1))
		if close.time_left == 0:
			close.start()

func _on_refresh_timeout() -> void:
	Collision.disabled = !Collision.disabled

func _on_close_timeout() -> void:
	queue_free()
