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
	var file = FileAccess.open("user://save.json",FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	highestUnlocked = data
	return data
	
func saveToFile(levelUnlocked:int):
	var file = FileAccess.open("user://save.json",FileAccess.WRITE)
	file.store_string(JSON.stringify(levelUnlocked))
	return true
