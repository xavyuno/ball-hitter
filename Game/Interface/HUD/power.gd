extends Control

@onready var holder = get_node("Scroll/Holder")

var Reset := false
var CashAmount = 0

func _ready() -> void:
	RefreshPowers()

func _physics_process(delta: float) -> void:
	$None.text = "Recieve " + str(CashAmount) + " cash"
	if System.RoundBegan:
		Reset = false
	if !Reset:
		Reset = true
		RefreshPowers()

func RefreshPowers():
	CashAmount = 25 * System.Round * System.Multiplier
	if holder.get_child_count() >= 1:
		for i in holder.get_children():
			i.queue_free()
	var Spawns := 5 - User.RoundPowers.size()
	var AvaiablePowers := []
	for i in User.PermPowers.size():
		if !(User.PermPowers.keys()[i] in User.RoundPowers.keys()):
			AvaiablePowers.append(User.PermPowers.keys()[i])
	if User.RoundPowers.size() >= 1:
		for i in User.RoundPowers.keys():
			var SelectPower = preload("res://Game/Interface/Power/power_select.tscn").instantiate()
			SelectPower.PowerID = i
			holder.add_child(SelectPower)
	if User.RoundPowers.size() < User.MaxPowers:
		for i in Spawns:
			randomize()
			var SelectPower = preload("res://Game/Interface/Power/power_select.tscn").instantiate()
			SelectPower.PowerID = AvaiablePowers[randi() % AvaiablePowers.size()]
			AvaiablePowers.erase(SelectPower.PowerID)
			holder.add_child(SelectPower)

func _on_none_pressed() -> void:
	User.Cash += CashAmount
	System.RoundBegan = true
	System.RoundEnded = false
	System.CurrentBlocks = System.SpawnsPerRound * System.WallSpace
	print("current Blocks: " + str(System.CurrentBlocks))
