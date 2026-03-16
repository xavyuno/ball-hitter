extends Area2D

@onready var Info: Label = $Info
@onready var MoveTime: Timer = $Move
@onready var Icon: TextureRect = $Icon
@onready var block: StaticBody2D = $Block
@onready var un_freeze: Timer = $UnFreeze

@export_enum("Normal", "Cash", "PowerUp", "Obstacle") var BlockType : int

var Health := 1
var Level := 1
var PowerUp := ["Power", "Rate", "Speed", "Balls"]
var SelectedPower := 0
var Frozen := false
var SetsID := 0
var Shrunk := false

func _ready() -> void:
	if System.RoundEnded:
		queue_free()
	if User.CheckPower("Ghost"):
		block.get_node("Collision").disabled = true
	if System.Round < 10:
		MoveTime.wait_time = System.MoveTime - (System.Round * 0.1)
	MoveTime.start()
	randomize()
	Level = randi() % 3 + 1
	SelectedPower = randi() % 4
	BlockType = randi() % 4
	if System.Round < 5:
		while BlockType == 3:
			BlockType = randi() % 4
	
	if System.Round < 2:
		Health = 1
	else :
		Health = randi() % (20 * System.Round * System.Difficulty * System.Multiplier)
		Health += 5 * System.Round
		if User.CheckPower("JackHammer"):
			Health *= User.RoundPowers["JackHammer"]

	match BlockType:
		0:
			Icon.texture = preload("res://Game/Assets/Icons/Blocks/Normal.png")
		1:
			Icon.texture = preload("res://Game/Assets/Icons/Blocks/Cash.png")
		2:
			Icon.texture = load("res://Game/Assets/Icons/Blocks/PowerUps/" + PowerUp[SelectedPower] + str(Level) + ".png")
			Info.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
		3:
			Icon.texture = preload("res://Game/Assets/Icons/Blocks/Obstacle.png")
			System.CurrentBlocks -= 1
			System.Sets[SetsID - 1] -= 1 
			Info.visible = false
	Info.text = str(Health)

func DealDamage(extra = 0):
	if User.CheckPower("Shrink") and !Shrunk:
		Shrunk = true
		scale -= Vector2(User.RoundPowers["Shrink"] * 0.1, User.RoundPowers["Shrink"] * 0.1)
	if User.CheckPower("Freeze"):
		Frozen = true
	if User.CheckPower("JackHammer"):
		if BlockType == 3:
			queue_free()
	
	if BlockType != 3:
		if extra == 0:
			if User.CheckPower("Ghost"):
				Health -= User.RoundStats["Damage"] * System.Multiplier * (User.RoundPowers["Ghost"] * 0.2)
			else :
				Health -= User.RoundStats["Damage"] * System.Multiplier
		else :
			Health -= extra

func _physics_process(delta: float) -> void:
	if System.RoundEnded:
		queue_free()
	Info.text = str(Health)
	if Health <= 0:
		User.Exp += ((1 * System.Difficulty * System.Round) / 2) * System.Multiplier + 1
		if User.CheckPower("Vampire"):
			for i in User.RoundPowers["Vampire"]:
				if User.Health < User.MaxHealth:
					User.Health += 1
		if User.CheckPower("Greed") and BlockType != 1:
			User.Cash += (randi() % (5 * System.Difficulty * System.Round * System.Multiplier)) * User.RoundPowers["Greed"]
		match BlockType:
			0:
				pass
			1:
				var temp = (randi() % (5 * System.Difficulty * System.Round * System.Multiplier * Level) + 1)
				if User.CheckPower("Greed"):
					temp *= User.RoundPowers["Greed"]
				User.Cash += temp
				System.Info(str(temp) + "+ Cash", global_position)
			2:
				match SelectedPower:
					0:
						User.RoundStats["Damage"] += (randi() % (5 * System.Difficulty * System.Round * System.Multiplier) + 1)
						System.Info(str(Level * User.RoundStats["Damage"]) + "+ Damage", global_position)
					1:
						User.RoundStats["Rate"] += Level
						System.Info(str(Level) + "+ Rate", global_position)
					2:
						User.RoundStats["Speed"] += Level * 5
						System.Info(str(Level * 5) + "+ Speed", global_position)
					3:
						User.RoundStats["Balls"] += Level
						System.Info(str(Level) + "+ Balls", global_position)
		System.CurrentBlocks -= 1
		print("Blocks Left: " + str(System.CurrentBlocks))
		System.Sets[SetsID - 1] -= 1 
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Ball"):
		body.bounce_count += 1
		if BlockType != 3 or User.CheckPower("JackHammer"):
			DealDamage()

func _on_move_timeout() -> void:
	if Frozen:
		if User.CheckPower("Freeze"):
			un_freeze.wait_time = User.RoundPowers["Freeze"]
			un_freeze.start()
		return
	if System.Round < 10:
		MoveTime.wait_time = System.MoveTime - (System.Round * 0.1)
		global_position.y += 64
	else :
		MoveTime.wait_time = 0.5
		global_position.y += 1 + System.Round
	if global_position.y > 640:
		if BlockType != 3:
			User.Health -= 1
			System.CurrentBlocks -= 1
			print("Blocks Left: " + str(System.CurrentBlocks))
			System.Sets[SetsID - 1] -= 1 
		queue_free()

func _on_un_freeze_timeout() -> void:
	Frozen = false
