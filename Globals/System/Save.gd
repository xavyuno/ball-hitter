extends Node

var FilePath := "user://Stats.txt"

func _ready() -> void:
	loadData()

func SaveData():
	print("saved")
	var data = [
		User.Cash,
		User.Damage,
		User.MaxHealth,
		User.MaxLives,
		User.MaxPowers,
		User.Rate,
		User.Speed,
		User.Rebirths,
		User.RebirthPoints,
		User.Balls
	]
	var File = FileAccess.open(FilePath, FileAccess.WRITE)
	File.store_var(data)
	File.close()

func loadData():
	var data = []

	if FileAccess.file_exists(FilePath):
		var File = FileAccess.open(FilePath, FileAccess.READ)
		data = File.get_var()
		File.close()
	else :
		SaveData()
	
	if data.size() >= 1:
		User.Cash = data[0]
		User.Damage = data[1]
		User.MaxHealth = data[2]
		User.MaxLives = data[3]
		User.MaxPowers = data[4]
		User.Rate = data[5]
		User.Speed = data[6]
		User.Rebirths = data[7]
		User.RebirthPoints = data[8]
		User.Balls = data[9]
