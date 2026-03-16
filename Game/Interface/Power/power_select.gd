extends Button

@onready var title: Label = $Title
@onready var Description: Label = $Desc

var PowerID := ""
var Desc := ""
var Amount := 1

func _ready() -> void:
	title.text = PowerID
	#icon = load("res://Game/Assets/Icons/Powers/" + PowerID + ".png")
	GetDesc()
	Description.text = Desc

func GetDesc():
	match PowerID:
		"Ghost":
			if User.CheckPower("Ghost"):
				Desc = ("Makes the balls phase through blocks. Uses " + 
				str((User.RoundPowers["Ghost"] + 1) * 20) + "% of the total damage \n" +
				"Does not work with Hit Scan"
				)
			else :
				Desc = ("Makes the balls phase through blocks. Uses " + 
				"20% of the total damage \n" +
				"Does not work with Hit Scan"
				)
		"Speedster":
			if User.CheckPower("Speedster"):
				Desc = ("Increases the ball's velocity after impact. Increases by " + 
				str(1 + (User.RoundPowers["Speedster"] + 1) * 0.1) + " after each bounce \n" +
				"Resets after being collected"
				)
			else :
				Desc = ("Increases the ball's velocity after impact. Increases by " + 
				"1.1 after each bounce \n" +
				"Resets after being collected"
				)
		"BuckShot":
			if User.CheckPower("BuckShot"):
				Desc = ("Spreads out the fire rays and adds " + str(2) +
				" balls. Total fire rays: " + 
				str((User.RoundPowers["BuckShot"] + 3)) + "\n" +
				"Works best with Hit Scan"
				)
			else :
				Desc = ("Spreads out the fire rays and adds 2" +
				" balls. Total fire rays: " + 
				"3\n" +
				"Works best with Hit Scan"
				)
		"HitScan":
			if User.CheckPower("HitScan"):
				Desc = ("Replaces the balls with hit scan rays and uses " + str(User.RoundPowers["HitScan"] + 1) +
				"x the total damage"
				)
			else :
				Desc = ("Replaces the balls with hit scan rays and uses 2" +
				"x the total damage" 
				)
		"Split":
			if User.CheckPower("Split"):
				Desc = ("Has a " + str((User.RoundPowers["Split"] + 1) * 10) +
				"% to split after impact \n" + 
				"Balls that came from spliting can not further split"
				)
			else :
				Desc = ("Has a 10%" +
				" to split after hitting a block \n" + 
				"Balls that came from spliting can not further split"
				)
		"Vampire":
			if User.CheckPower("Vampire"):
				Desc = ("Adds " + str(User.RoundPowers["Vampire"] + 1) +
				" to the total health after destroying a block \n" + 
				"Can not go past maximum health"
				)
			else :
				Desc = ("Adds 1" +
				" to the total health after destroying a block \n" + 
				"Can not go past maximum health"
				)
		"Greed":
			if User.CheckPower("Greed"):
				Desc = ("All Blocks gives cash and multiplies cash by " + str(User.RoundPowers["Greed"] + 1)
				)
			else :
				Desc = ("All Blocks gives cash and multiplies cash by 1"
				)
		"JackHammer":
			if User.CheckPower("JackHammer"):
				Desc = ("Allows obstacle blocks to be destroyed but increases health of all other blocks by " + 
				str(User.RoundPowers["JackHammer"] + 1) + "x and adds " + str(User.RoundPowers["JackHammer"] + 1)
				 + " damage"
				)
			else :
				Desc = ("Allows obstacle blocks to be destroyed but increases health of all other blocks by " + 
				str(1) + "x and adds " + str(1)
				 + " damage"
				)
		"Explode":
			if User.CheckPower("Explode"):
				Desc = ("Has a " + str((User.RoundPowers["Explode"] + 1) * 10) +
				"% to cause an explosion after impact"
				)
			else :
				Desc = ("Has a 10%" +
				" to cause an explosion after impact"
				)
		"Freeze":
			if User.CheckPower("Freeze"):
				Desc = ("Freezes block after impact for " + str((User.RoundPowers["Freeze"] + 1)) +
				" seconds"
				)
			else :
				Desc = ("Freezes block after impact for " + str((1)) +
				" second"
				)
		"Push":
			if User.CheckPower("Push"):
				Desc = ("Pushes block after by " + str((User.RoundPowers["Push"] + 1)) +
				"x the impact"
				)
			else :
				Desc = ("Pushes block after by " + str(( 1)) +
				"x the impact"
				)
		"Grow":
			if User.CheckPower("Grow"):
				Desc = ("The Ball grows in size once after impact by " + str(float(User.RoundPowers["Grow"]) * 0.1) +
				" the size"
				)
			else :
				Desc = ("The Ball grows in size after impact by 0.1" +
				" the size"
				)
		"Shrink":
			if User.CheckPower("Shrink"):
				Desc = ("The Block shrinks in size after impact by " + str(float(User.RoundPowers["Shrink"]) * 0.1) +
				" the size"
				)
			else :
				Desc = ("The Block shrinks in size after impact by 0.1" +
				" the size"
				)

func _on_pressed() -> void:
	if User.RoundPowers.has(PowerID):
		if PowerID == "BuckShot":
			User.RoundPowers[PowerID] += 2
			User.RoundStats["Balls"] += 2
		elif PowerID == "JackHammer":
			User.RoundStats["Damage"] += User.RoundStats["JackHammer"]
		else :
			User.RoundPowers[PowerID] += Amount
	else :
		if PowerID == "BuckShot":
			User.RoundPowers.merge({PowerID:1}, true)
			User.RoundStats["Balls"] += 2
		else :
			User.RoundPowers.merge({PowerID:Amount}, true)
	System.RoundBegan = true
	System.RoundEnded = false
	System.CurrentBlocks = System.SpawnsPerRound * System.WallSpace
	System.Sets = []
	for i in System.SpawnsPerRound:
		System.Sets.append(System.WallSpace)
	print("current Blocks: " + str(System.CurrentBlocks))
