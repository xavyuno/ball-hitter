extends CharacterBody2D

@onready var AimTimer: Timer = $AimTimer
@onready var Balls: Label = $Balls
@onready var hit_scans: Node2D = $Head/HitScans
@onready var aims: Node2D = $Head/Aims

var Speed := 120
var Accel := 10

var Shooting:= false
var TotalHitScans := 1

var CapturedRot = 0
var CapturedPos

func CreateHitScan(aim = false):
	var Rot = 180 / TotalHitScans
	var CRot = 0
	var Div = -1
	var R = 2
	var B := 1
	for a in TotalHitScans:
		var HitScan = preload("res://Game/Assets/Scenes/HitScan/hit_scan.tscn").instantiate()
		if a == 0:
			HitScan.rotation_degrees = 0
		else :
			B = R / 2
			if B <= 0:
				CRot = Rot * Div
			else :
				CRot = Rot * Div / B
			R += 1
			HitScan.rotation_degrees = CRot
		Div *= -1
		if !User.CheckPower("HitScan"):
			if User.RoundStats["Balls"] >= 1:
				User.RoundStats["Balls"] -= 1
				var Ball = preload("res://Game/Assets/Scenes/Ball/ball.tscn").instantiate()
				Ball.global_position = hit_scans.global_position + Vector2(0, 0)
				if a == 0:
					Ball.global_rotation_degrees = hit_scans.global_rotation_degrees + 90
				else :
					Ball.global_rotation_degrees = HitScan.global_rotation_degrees + 90
				Ball.Damage = User.RoundStats["Damage"]
				get_tree().root.add_child(Ball)
		else :
			HitScan.Aim = aim
			hit_scans.add_child(HitScan)

func CreateAim():
	var Rot = 180 / TotalHitScans
	var CRot = 0
	var Div = -1
	var R = 2
	var B := 1
	if aims.get_child_count() >= 1:
		for b in aims.get_children():
			b.queue_free()
	for a in TotalHitScans:
		var HitScan = preload("res://Game/Assets/Scenes/HitScan/hit_scan.tscn").instantiate()
		if a == 0:
			HitScan.rotation_degrees = 0
		else :
			B = R / 2
			if B <= 0:
				CRot = Rot * Div
			else :
				CRot = Rot * Div / B
			R += 1
			HitScan.rotation_degrees = CRot
		Div *= -1
		HitScan.Aim = true
		aims.add_child(HitScan)

func Shoot():
	for i in User.RoundStats["Rate"]:
		if hit_scans.get_child_count() >= 1:
			for b in hit_scans.get_children():
				b.Aim = false
		else :
			CreateHitScan()
		if User.RoundStats["Rate"] > 1:
			await get_tree().create_timer(0.15).timeout
	Shooting = false
	User.Aiming = false

func Movement():
	if !User.Aiming:
		global_position.x = get_global_mouse_position().x
	global_position.x = clamp(global_position.x, System.MinX + 32, System.MaxX - 32)

func GetVel():
	var Motion = Vector2.ZERO
	Motion.x = Input.get_axis("Left", "Right")
	return Motion * Speed

func UserInput():
	if User.CheckPower("BuckShot"):
		TotalHitScans = 2 + User.RoundPowers["BuckShot"]
	else :
		TotalHitScans = 1
	if Input.is_action_just_pressed("Shoot") and !System.Reseting:
		AimTimer.start()
	if Input.is_action_just_released("Shoot") and !System.Reseting:
		AimTimer.stop()
		if aims.get_child_count() >= 1:
			for b in aims.get_children():
				b.queue_free()
		if User.RoundStats["Balls"] > 0 and !Shooting:
			Shooting = true
			await Shoot()
			User.Aiming = false

func _physics_process(delta: float) -> void:
	if System.CanInput:
		UserInput()
	Movement()
	Balls.text = str(User.RoundStats["Balls"])
	if User.Aiming:
		hit_scans.rotation_degrees = 90
		CapturedRot = $Head.rotation_degrees
		if get_global_mouse_position().y < 688:
			$Head.look_at(get_global_mouse_position())
	else :
		hit_scans.rotation_degrees = 0
		$Head.rotation_degrees = 0


func _on_aim_timer_timeout() -> void:
	User.Aiming = true
	if User.CheckPower("HitScan"):
		CreateHitScan(true)
	else :
		CreateAim()
