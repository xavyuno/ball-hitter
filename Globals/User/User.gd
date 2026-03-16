extends Node

var Rebirths := 0
var RebirthPoints := 0
var Cash := 0

var Level := 1
var Exp := 0
var ReqExp := 10

var Health := 5
var MaxHealth := 5
var Lives := 1
var MaxLives := 1

var Aiming := false
var Balls := 1
var Rate := 1
var Speed := 250

var Damage := 1

var RoundStats := {
	"Damage" : 0,
	"Speed" : 0,
	"Rate" : 0,
	"Balls" : 0
}

var MaxPowers := 3

var PermPowers := {
	"Ghost" : 0,
	"Speedster" : 0,
	"BuckShot" : 0,
	"HitScan" : 0,
	"Split" : 0,
	"Vampire" : 0,
	"Greed" : 0,
	"JackHammer" : 0,
	"Explode" : 0,
	"Freeze" : 0,
	"Push" : 0,
	"Grow" : 0,
	"Shrink" : 0
}

var RoundPowers := {}

var GameOver := false

func LevelSystem():
	if Exp >= ReqExp:
		Exp -= ReqExp
		Level += 1
		ReqExp *= 1.5

func HealthSystem():
	if Health <= 0:
		Health = MaxHealth
		Lives -= 1
		if Lives <= 0:
			GameOver = true
	if GameOver:
		GameOver = false
		Health = MaxHealth
		Lives = MaxLives
		System.Restart()

func ResetStats():
	RoundStats["Damage"] = Damage
	RoundStats["Speed"] = Speed
	RoundStats["Rate"] = Rate
	RoundStats["Balls"] = Balls
	RoundPowers = {}
	
	for i in PermPowers.size():
		if PermPowers.values()[i] >= 1:
			RoundPowers.merge({PermPowers.keys()[i]:PermPowers.values()[i]}, true)
	if PermPowers["BuckShot"]:
		Balls += 2
	
	await get_tree().create_timer(0.5).timeout
	System.Reseting = false

func CheckPower(PowerID:String):
	if RoundPowers.has(PowerID):
		return true
	else :
		return false

func _physics_process(delta: float) -> void:
	HealthSystem()
	LevelSystem()
