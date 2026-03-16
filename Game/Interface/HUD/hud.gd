extends Control

@onready var health: Label = $Holder/Health
@onready var cash: Label = $Holder/Cash
@onready var level: TextureProgressBar = $Holder/Level
@onready var info: Label = $Holder/Level/Info
@onready var round: Label = $Holder/Round
@onready var end: Button = $End
@onready var tab: Control = $Tab

func _physics_process(delta: float) -> void:
	health.text = "HP: " + str(User.Health)
	cash.text = "Cash: " + str(User.Cash)
	level.max_value = User.ReqExp
	level.value = User.Exp
	info.text = str(User.Level)
	round.text = "Round: " + str(System.Round)
	if System.RoundEnded:
		tab.visible = true
		end.visible = false
	else :
		tab.visible = false
		end.visible = true

func _on_start_pressed() -> void:
	System.RoundBegan = true
	System.RoundEnded = false
	System.CurrentBlocks = System.SpawnsPerRound * System.WallSpace
	print("current Blocks: " + str(System.CurrentBlocks))
	
func _on_end_pressed() -> void:
	System.Restart()
