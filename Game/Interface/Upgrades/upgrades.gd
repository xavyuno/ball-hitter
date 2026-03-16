extends Control

@onready var holder: HFlowContainer = $Scroll/Holder

var UName = ["Balls", "Health", "Rate", "Speed", "Damage", "Lives", "MaxPowers"]

func _ready() -> void:
	for i in UName.size():
		var upgrade = preload("res://Game/Interface/Upgrades/upgrade.tscn").instantiate()
		upgrade.UName = UName[i]
		holder.add_child(upgrade)
