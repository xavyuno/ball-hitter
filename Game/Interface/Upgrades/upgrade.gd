extends Button

@onready var title: Label = $Title
@onready var desc: Label = $Desc
@onready var amount: Label = $Amount

var UName : String

var description := ""
var ReqAmount := 0

func Desc():
	match UName:
		"Balls":
			description = "Increases the total balls by 1"
			ReqAmount = User.Balls * 5.25
		"Health":
			description = "Increases max health by 1"
			ReqAmount = User.MaxHealth * 2.5
		"Rate":
			description = "Increases rate at which balls are shot"
			ReqAmount = User.Rate * 5.5
		"Speed":
			description = "Increases ball speed by 25"
			ReqAmount = User.Speed * .1
		"Damage":
			description = "Increases damage by 1"
			ReqAmount = User.Damage * 9.5
		"Lives":
			description = "Increases max lives by 1"
			ReqAmount = User.MaxLives * 1000
		"MaxPowers":
			description = "Increases max lives by 1"
			ReqAmount = User.MaxPowers * 1000

func _process(delta: float) -> void:
	title.text = UName
	desc.text = description
	amount.text = str(ReqAmount) + "$"
	Desc()

func _on_pressed() -> void:
	if User.Cash >= ReqAmount:
		User.Cash -= ReqAmount
		match UName:
			"Balls":
				User.Balls += 1
				User.RoundStats[UName] += 1
			"Health":
				User.MaxHealth += 1
				User.Health = User.MaxHealth
			"Rate":
				User.Rate += 1
				User.RoundStats[UName] += 1
			"Speed":
				User.Speed += 25
				User.RoundStats[UName] += 25
			"Damage":
				User.Damage += 1
				User.RoundStats[UName] += 1
			"Lives":
				User.MaxLives += 1
			"MaxPowers":
				User.MaxPowers += 1
