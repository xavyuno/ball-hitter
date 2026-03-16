extends CharacterBody2D

@onready var Col: CollisionShape2D = $Collision

var BallSize := 8
var bounce_count := 0
var Damage := 1
var TempVel = 1
var SplitChance := 10
var ExplodeChance := 10
var CanCollect := true
var Split := false
var Grew := false

func _ready():
	# Start with a direction. You can set this from outside before adding to the scene.
	velocity = (-Vector2.RIGHT.rotated(rotation) * (User.RoundStats["Speed"] + TempVel))

func _physics_process(delta):
	var collision = move_and_collide(velocity * TempVel * delta)
	if User.CheckPower("HitScan"):
		if CanCollect:
			User.RoundStats["Balls"] += 1
		queue_free()
	if System.Reseting:
		queue_free()

	if collision:
		velocity = velocity.bounce(collision.get_normal())
		bounce_count += 1
		randomize()
		if User.CheckPower("Split") and "Block" in collision.get_collider().name and !Split:
			Split = true
			var Chance := randi() % 100
			if Chance <= (SplitChance * User.RoundPowers["Split"]):
				var Ball = preload("res://Game/Assets/Scenes/Ball/ball.tscn").instantiate()
				Ball.global_position = global_position
				Ball.rotation_degrees = rotation_degrees
				Ball.Damage = User.RoundStats["Damage"]
				Ball.CanCollect = false
				Ball.Split = true
				get_tree().root.add_child(Ball)
		if User.CheckPower("Explode") and "Block" in collision.get_collider().name:
			var Chance := randi() % 100
			if Chance <= (ExplodeChance * User.RoundPowers["Explode"]):
				var Explode = preload("res://Game/Assets/Scenes/Explosion/explosion.tscn").instantiate()
				Explode.global_position = global_position
				get_tree().root.add_child(Explode)
		if User.CheckPower("Speedster") and "Block" in collision.get_collider().name:
			TempVel = 1 + (User.RoundPowers["Speedster"] * 0.1) * bounce_count
		if User.CheckPower("Push") and "Block" in collision.get_collider().name:
			collision.get_collider().get_parent().position += velocity.bounce(collision.get_normal()).normalized() * User.RoundPowers["Push"]
		if User.CheckPower("Grow") and "Block" in collision.get_collider().name and !Grew:
			Grew = true
			scale += Vector2(User.RoundPowers["Grow"] * 0.1, User.RoundPowers["Grow"] * 0.1)
			BallSize += 4

func _draw() -> void:
	draw_circle(Vector2(0, 0),
	BallSize,
	Color.ALICE_BLUE
	)
