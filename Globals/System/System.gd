extends Node

var CanInput := false

var WallSpace := 3
var MinX := 0
var MaxX := 0

var RoundBegan := false
var RoundEnded := false
var RoundBusy := false
var Difficulty := 1
var Round := 1
var SpawnsPerRound = 3
var CurrentSpawns := 0
var CurrentBlocks := 0
var Sets := []
var Multiplier := 1
var Reseting := false

var SpawmTime := 1
var MoveTime := 1

func _ready() -> void:
	Restart()

func SetUpSpawns():
	System.WallSpace = 3 + ((System.Round / 5) * 2)
	SpawnsPerRound = 3
	var temp = 1
	for i in Round:
		SpawnsPerRound += temp
		temp += 1

func Restart():
	Reseting = true
	WallSpace = 3
	RoundBegan = false
	RoundEnded = true
	RoundBusy = false
	Round = 1
	SpawnsPerRound = 3
	CurrentSpawns = 0
	CurrentBlocks = 0
	Multiplier = 1
	SpawmTime = 3
	MoveTime = 2
	User.ResetStats()

func Info(txt: String, pos: Vector2, col = Color.WHITE):
	var info = preload("res://Game/Assets/Scenes/Info/info.tscn").instantiate()
	info.global_position = pos
	info.text = txt
	info.modulate = col
	get_tree().root.add_child(info)
