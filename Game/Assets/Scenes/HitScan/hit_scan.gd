extends RayCast2D

var ColPoint := Vector2(0, -5000)
var Aim := false

func _physics_process(delta: float) -> void:
	if is_colliding():
		if User.CheckPower("HitScan") and !Aim:
			if get_collider().is_in_group("Block"):
				get_collider().get_parent().DealDamage(User.RoundStats["Damage"] * User.RoundPowers["HitScan"] + 1)
				queue_free()
			else :
				queue_free()

func _draw() -> void:
	draw_line(Vector2.ZERO, ColPoint, Color(Color.RED, 0.5), 5)
