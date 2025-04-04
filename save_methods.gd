extends Node
var highestUnlocked = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	highestUnlocked = loadFromFile()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func unlockCheck(levelNumber:int):
	if levelNumber > highestUnlocked:
		highestUnlocked = levelNumber
		saveToFile(levelNumber)

func loadFromFile():
	if FileAccess.file_exists("user://save.json"):
		var file = FileAccess.open("user://save.json",FileAccess.READ)
		var data = JSON.parse_string(file.get_as_text())
		if data is Dictionary:
			# Save format 2
			highestUnlocked = data["highestUnlockedLevel"]
			return data["highestUnlockedLevel"]
		elif data is float:
			# save format 1 (Just in case)
			highestUnlocked = data
			saveToFile(data)
			return data
		else:
			# Data is corrupt for some reason
			highestUnlocked = 1
			return 1
	else:
		highestUnlocked = 1
		return 1
	
func saveToFile(levelUnlocked:int):
	var file = FileAccess.open("user://save.json",FileAccess.WRITE)
	var dataDict = {"highestUnlockedLevel":levelUnlocked}
	file.store_string(JSON.stringify(dataDict))
	return true
