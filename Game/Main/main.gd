extends Node2D

@onready var BlocksSpawner: Node2D = $BlocksSpawner
@onready var Blocks: Node2D = $Blocks
@onready var SpawnTimer: Timer = $SpawnTimer

func SpawnBlocks():
	SpawnTimer.wait_time = System.SpawmTime - (System.Round * 0.1)
	System.CurrentSpawns += 1
	for i in System.WallSpace:
		randomize()
		var Chance = randi() % 100
		if Chance <= 75:
			var Block = preload("res://Game/Assets/Scenes/Block/block.tscn").instantiate()
			Block.global_position = BlocksSpawner.get_child(i).global_position
			Block.SetsID = System.CurrentSpawns
			Blocks.add_child(Block)
		else :
			System.CurrentBlocks -= 1
			System.Sets[System.CurrentSpawns - 1] -= 1 
	System.RoundBusy = true
	print("Current Spawns: " + str(System.CurrentSpawns) + "/" + str(System.SpawnsPerRound))

func _ready() -> void:
	SpawnTimer.wait_time = System.SpawmTime - (System.Round * 0.1)
	print(SpawnTimer.wait_time)
	System.SetUpSpawns()

func _on_collect_body_entered(body: Node2D) -> void:
	if body.is_in_group("Ball"):
		body.queue_free()
		if body.CanCollect:
			User.RoundStats["Balls"] += 1

func _on_spawn_timer_timeout() -> void:
	if System.CurrentSpawns < System.SpawnsPerRound and !System.RoundEnded:
		SpawnBlocks()
		SpawnTimer.start()

func _physics_process(delta: float) -> void:
	if System.RoundBegan:
		if !System.RoundBusy:
			if SpawnTimer.time_left == 0:
				SpawnTimer.start()
		else :
			if System.CurrentBlocks <= 0:
				SpawnTimer.stop()
				System.RoundBegan = false
				System.RoundEnded = true
				System.RoundBusy = false
				System.CurrentSpawns = 0
				System.Round += 1
				System.SetUpSpawns()
				print("spawns: " + str(System.SpawnsPerRound))

func _on_refresher_timeout() -> void:
	if System.RoundBegan:
		var SetsCompleted := 0
		for i in System.CurrentSpawns:
			if System.Sets[i] == 0:
				SetsCompleted += 1
		if SetsCompleted >= System.CurrentSpawns:
			if System.CurrentSpawns < System.SpawnsPerRound and !System.RoundEnded:
				SpawnBlocks()
				SpawnTimer.start()

func _on_input_focus_entered() -> void:
	System.CanInput = true

func _on_input_focus_exited() -> void:
	System.CanInput = false

func _on_input_mouse_entered() -> void:
	System.CanInput = true

func _on_input_mouse_exited() -> void:
	System.CanInput = false
