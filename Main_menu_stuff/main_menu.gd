extends Node2D

signal loadLevel(level: int)
@export var levels_ui_scene: PackedScene
var menuState = "titleScreen"
var selectedLevel = [[false, false, false, false, false],[false, false, false, false, false],[false, false, false, false, false],[false, false, false, false, false],[false, false, false, false, false]]
var page = 1
const numberOfLevels = 5 #This needs to be updated to the number of levels in the final product
var numberOfPages = null #This does not need to be updated.

var highestUnlockedlevel = 1 #something else needs to change this.

var disabled = true

# Called when the node enters the scene tree for the first time.
func _ready():
	# load highest level from file, and make sure it isn't over the total levels in the game
	highestUnlockedlevel = SaveHandler.loadFromFile()
	if highestUnlockedlevel > numberOfLevels:
		highestUnlockedlevel = numberOfLevels
		SaveHandler.saveToFile(highestUnlockedlevel)
	get_node("title").hide()
	get_node("page_icons/Selected_page_icon").hide()
	get_node("page_icons").hide()
	self.hide()
	get_node("start_button").hide()
	get_node("quit_button").hide()
	get_node("playerSelection").hide()	
	get_node("playerSelection").z_index = 2
	setupTitleScreen() #Testing only
	disabled = false
	
	#calculate numberOfPages variable
	if((numberOfLevels % 15) != 0):
		numberOfPages = floor(numberOfLevels/15) + 1
	else:
		numberOfPages = floor(numberOfLevels/15)

func setupTitleScreen():
	get_node("title").show()
	get_node("page_icons/Selected_page_icon").hide()
	get_node("page_icons").hide()
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
	get_node("title").hide()
	get_node("page_icons").show()
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
		if(i > highestUnlockedlevel):	
			levels_ui_instance.locked = true
		else:
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
		add_child(levels_ui_instance)	
		pageTracker[1] += 1
		if(pageTracker[1] == 15):
			pageTracker[1] = 0
			pageTracker[0] += 1
	
	if(numberOfPages % 2 != 0):
		get_node("page_icons/odd_page_icons").show()
		get_node("page_icons/even_page_icons").hide()
		if(numberOfPages == 1): #no need for a page ui if there's only one page...
			get_node("page_icons/odd_page_icons").hide()
		elif(numberOfPages == 3):
			get_node("page_icons/odd_page_icons/page_slot_1").hide()
			get_node("page_icons/odd_page_icons/page_slot_2").hide()
			get_node("page_icons/odd_page_icons/page_slot_6").hide()
			get_node("page_icons/odd_page_icons/page_slot_7").hide()
		elif(numberOfPages == 5):
			get_node("page_icons/odd_page_icons/page_slot_1").hide()
			get_node("page_icons/odd_page_icons/page_slot_7").hide()
		#elif(numberOfPages == 7): #Use all of them, no need to hide any
	elif(numberOfPages % 2 == 0):
		get_node("page_icons/even_page_icons").show()
		get_node("page_icons/odd_page_icons").hide()
		if(numberOfPages == 2):
			get_node("page_icons/even_page_icons/page_slot_1").hide()
			get_node("page_icons/even_page_icons/page_slot_2").hide()
			get_node("page_icons/even_page_icons/page_slot_5").hide()
			get_node("page_icons/even_page_icons/page_slot_6").hide()
		elif(numberOfPages == 4):
			get_node("page_icons/even_page_icons/page_slot_1").hide()
			get_node("page_icons/even_page_icons/page_slot_6").hide()
		#elif(numberOfPages == 6): #Use all of them, no need to hide any
		
	get_node("page_icons/Selected_page_icon").show()
	get_node("page_icons/Selected_page_icon").z_index = 2


	#show page 1 of all the levels.
	for node in get_tree().get_nodes_in_group("page1"):
		node.show()


func update_page(oldPage, newPage):
	if(oldPage == newPage):
		print("Error from Main_menu.gd: Called update_page function with 2 equal page values.")
	else:
		for node in get_tree().get_nodes_in_group("page" + str(oldPage)):
			node.hide()
		for node in get_tree().get_nodes_in_group("page" + str(newPage)):
			node.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	
	if(disabled == false):
		#update little yellow dot ("Selected_page_icon") to correct location
		if(numberOfPages % 2 != 0):
			get_node("page_icons/Selected_page_icon").position = get_node("page_icons/odd_page_icons/page_slot_" + str(page + ((7 - numberOfPages)/2))).position
		elif(numberOfPages % 2 == 0):
			get_node("page_icons/Selected_page_icon").position = get_node("page_icons/even_page_icons/page_slot_" + str(page + ((7 - numberOfPages)/2))).position
		
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
							if(page != 1):
								page = clamp(page - 1, 1, numberOfPages)
								update_page(page + 1, page)
								selectedLevel[i][j] = false
								selectedLevel[i][4] = true
							found = true
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
						elif((selectedLevel[i][j] == true) && (j == 4)):
							if(page != numberOfPages):
								page = clamp(page + 1, 1, numberOfPages)
								update_page(page - 1, page)
								selectedLevel[i][j] = false
								selectedLevel[i][0] = true
								found = true
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
					
					
		if Input.is_action_just_pressed("interact"):
			if(menuState == "titleScreen"):
				if(get_node("playerSelection").position == get_node("start_button").position):
					setupLevelSelect()
				elif(get_node("playerSelection").position == get_node("quit_button").position):
					get_tree().quit()
			elif(menuState == "levelSelect"):
				var found = false
				for i in range(0, 3, 1):
					for j in range(0, 5, 1):
						if(selectedLevel[i][j] == true):
							if((((i*5)+(j+1))+((page-1)*15) <= numberOfLevels) and ((((i*5)+(j+1))+((page-1)*15) <= highestUnlockedlevel))):
								self.hide()
								emit_signal("loadLevel", ((i*5)+(j+1))+((page-1)*15))
								disabled = true
								#print("i just loaded a level")
							#else:
								#insert 'incorrect buzzer' sound here?
							found = true
						if(found == true):
							break
					if(found == true):
						break
		
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
	
	
