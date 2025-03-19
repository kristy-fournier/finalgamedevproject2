extends Node2D

signal startLevel(level)
@export var levels_ui_scene: PackedScene
var menuState = "titleScreen"
var selectedLevel = [[false, false, false, false, false],[false, false, false, false, false],[false, false, false, false, false],[false, false, false, false, false],[false, false, false, false, false]]
var page = 1
const numberOfLevels = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()
	get_node("start_button").hide()
	get_node("quit_button").hide()
	get_node("playerSelection").hide()	
	get_node("playerSelection").z_index = 2
	setupTitleScreen() #Testing only

func setupTitleScreen():
	self.show()
	get_node("start_button").show()
	get_node("quit_button").show()
	get_node("playerSelection").show()
	get_node("playerSelection").scale = Vector2(1.5, 1.5)
	get_node("playerSelection").frame = 0
	selectedLevel = [[false, false, false, false, false],[false, false, false, false, false],[false, false, false, false, false],[false, false, false, false, false],[false, false, false, false, false]]
	get_node("playerSelection").position = get_node("start_button").position
	menuState = "titleScreen"

func setupLevelSelect():
	self.show()
	get_node("start_button").hide()
	get_node("quit_button").hide()
	get_node("playerSelection").show()
	get_node("playerSelection").scale = Vector2(2, 2)
	selectedLevel = [[true, false, false, false, false],[false, false, false, false, false],[false, false, false, false, false]]
	get_node("playerSelection").frame = 1
	menuState = "levelSelect"
	var pageTracker = [0, 0]
	for i in range(1, numberOfLevels + 1, 1):
		var levels_ui_instance = levels_ui_scene.instantiate()
		levels_ui_instance.number = i
		levels_ui_instance.locked = false
		levels_ui_instance.scale = Vector2(2, 2)
		if(i == (1 + (15 * pageTracker[0]))):
			levels_ui_instance.background = "purple"
			levels_ui_instance.position = get_node("level_slot_1").position
		elif(i == (2 + (15 * pageTracker[0]))):
			levels_ui_instance.background = "purple"
			levels_ui_instance.position = get_node("level_slot_2").position
		elif(i == (3 + (15 * pageTracker[0]))):
			levels_ui_instance.background = "purple"
			levels_ui_instance.position = get_node("level_slot_3").position
		elif(i == (4 + (15 * pageTracker[0]))):
			levels_ui_instance.background = "purple"
			levels_ui_instance.position = get_node("level_slot_4").position
		elif(i == (5 + (15 * pageTracker[0]))):
			levels_ui_instance.background = "purple"
			levels_ui_instance.position = get_node("level_slot_5").position
		elif(i == (6 + (15 * pageTracker[0]))):
			levels_ui_instance.background = "blue"
			levels_ui_instance.position = get_node("level_slot_6").position
		elif(i == (7 + (15 * pageTracker[0]))):
			levels_ui_instance.background = "blue"
			levels_ui_instance.position = get_node("level_slot_7").position
		elif(i == (8 + (15 * pageTracker[0]))):
			levels_ui_instance.background = "blue"
			levels_ui_instance.position = get_node("level_slot_8").position
		elif(i == (9 + (15 * pageTracker[0]))):
			levels_ui_instance.background = "blue"
			levels_ui_instance.position = get_node("level_slot_9").position
		elif(i == (10 + (15 * pageTracker[0]))):
			levels_ui_instance.background = "blue"
			levels_ui_instance.position = get_node("level_slot_10").position
		elif(i == (11 + (15 * pageTracker[0]))):
			levels_ui_instance.background = "black"
			levels_ui_instance.position = get_node("level_slot_11").position
		elif(i == (12 + (15 * pageTracker[0]))):
			levels_ui_instance.background = "black"
			levels_ui_instance.position = get_node("level_slot_12").position
		elif(i == (13 + (15 * pageTracker[0]))):
			levels_ui_instance.background = "black"
			levels_ui_instance.position = get_node("level_slot_13").position
		elif(i == (14 + (15 * pageTracker[0]))):
			levels_ui_instance.background = "black"
			levels_ui_instance.position = get_node("level_slot_14").position
		elif(i == (15 + (15 * pageTracker[0]))):
			levels_ui_instance.background = "black"
			levels_ui_instance.position = get_node("level_slot_15").position
			print(pageTracker)
		add_child(levels_ui_instance)	
		pageTracker[1] += 1
		if(pageTracker[1] == 15):
			pageTracker[1] = 0
			pageTracker[0] += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	if Input.is_action_just_pressed("move_left"):
		if(menuState == "titleScreen"):
			if(get_node("playerSelection").position == get_node("quit_button").position):
				get_node("playerSelection").position = get_node("start_button").position
		if(menuState == "levelSelect"):
			var found = false
			for i in range(0, 3, 1):
				for j in range(0, 5, 1):
					if(found == true):
						break
					if((selectedLevel[i][j] == true) && (j != 0)):
						selectedLevel[i][j] = false
						selectedLevel[i][j - 1] = true
						found = true
					elif((selectedLevel[i][j] == true) && (j == 0)):
						page = clamp(page - 1, 1, 999)
					if(found == true):
						break
	
	if Input.is_action_just_pressed("move_right"): 
		if(menuState == "titleScreen"):
			if(get_node("playerSelection").position == get_node("start_button").position):
				get_node("playerSelection").position = get_node("quit_button").position
		if(menuState == "levelSelect"):
			var found = false
			for i in range(0, 3, 1):
				if(found == true):
					break
				for j in range(0, 5, 1):
					if((selectedLevel[i][j] == true) && (j != 4)):
						selectedLevel[i][j] = false
						selectedLevel[i][j + 1] = true
						found = true
					elif((selectedLevel[i][j] == true) && (j == 0)):
						#page = clamp(page + 1, 999, (numberOfLevels // 15))
						print("w")
					if(found == true):
						break
						
	if Input.is_action_just_pressed("move_up"):
		if(menuState == "levelSelect"):
			var found = false
			for i in range(0, 3, 1):
				if(found == true):
					break
				for j in range(0, 5, 1):
					if((selectedLevel[i][j] == true) && (i != 0)):
						selectedLevel[i][j] = false
						selectedLevel[i - 1][j] = true
						found = true
					if(found == true):
						break
	
	if Input.is_action_just_pressed("move_down"):
		if(menuState == "levelSelect"):
			var found = false
			for i in range(0, 3, 1):
				if(found == true):
					break
				for j in range(0, 5, 1):
					if((selectedLevel[i][j] == true) && (i != 2)):
						selectedLevel[i][j] = false
						selectedLevel[i + 1][j] = true
						found = true
					if(found == true):
						break
				
				
	if Input.is_action_just_pressed("menu_confirm"):
		if(menuState == "titleScreen"):
			if(get_node("playerSelection").position == get_node("start_button").position):
				setupLevelSelect()
			elif(get_node("playerSelection").position == get_node("quit_button").position):
				get_tree().quit()
	
	if(selectedLevel[0][0] == true):
		get_node("playerSelection").position = get_node("level_slot_1").position
	elif(selectedLevel[0][1] == true):
		get_node("playerSelection").position = get_node("level_slot_2").position
	elif(selectedLevel[0][2] == true):
		get_node("playerSelection").position = get_node("level_slot_3").position
	elif(selectedLevel[0][3] == true):
		get_node("playerSelection").position = get_node("level_slot_4").position
	elif(selectedLevel[0][4] == true):
		get_node("playerSelection").position = get_node("level_slot_5").position
	elif(selectedLevel[1][0] == true):
		get_node("playerSelection").position = get_node("level_slot_6").position
	elif(selectedLevel[1][1] == true):
		get_node("playerSelection").position = get_node("level_slot_7").position
	elif(selectedLevel[1][2] == true):
		get_node("playerSelection").position = get_node("level_slot_8").position
	elif(selectedLevel[1][3] == true):
		get_node("playerSelection").position = get_node("level_slot_9").position
	elif(selectedLevel[1][4] == true):
		get_node("playerSelection").position = get_node("level_slot_10").position
	elif(selectedLevel[2][0] == true):
		get_node("playerSelection").position = get_node("level_slot_11").position
	elif(selectedLevel[2][1] == true):
		get_node("playerSelection").position = get_node("level_slot_12").position
	elif(selectedLevel[2][2] == true):
		get_node("playerSelection").position = get_node("level_slot_13").position
	elif(selectedLevel[2][3] == true):
		get_node("playerSelection").position = get_node("level_slot_14").position
	elif(selectedLevel[2][4] == true):
		get_node("playerSelection").position = get_node("level_slot_15").position
	
			
			
			
			
			
			
			
			
