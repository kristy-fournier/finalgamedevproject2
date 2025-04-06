extends Node
var item_map
@onready var character = $"CurrentLevelContent/Character"
var current_floor
var current_floor_node
var in_menu = false
var currentLevel
var in_main_menu
var current_floor_letter
@onready var levelSongs = [load("res://Sound/ghost1.wav"),load("res://Sound/ghost2.wav"),load("res://Sound/ghost3.wav")] 
@onready var main_menu = find_child("Main_menu")
signal get_center(center: Vector2)

#MUST BE CHANGED IF ANY CHANGES TO TILE SET HAPPEN
const current_tile_set_id = 0
const trapdoor_open_coord = Vector2(2,0)
const trapdoor_closed_coord = Vector2(1,0)

const broken_2_coord = Vector2(1,3)
const hole_coord = Vector2(2,2)
const broken_hole_coord = Vector2(2,3)
const ground_hole_coord = Vector2(1,4)
const ground_broken_hole_coord = Vector2(3,4)
const ground_broken_2_coord = Vector2(2,4)
const ladder_grey_coord = Vector2(3,0)
const ladder_coord = Vector2(0,4)
const hole_ladder_coord = Vector2(3,2)
const broken_hole_ladder_coord = Vector2(3,3)


# this line below should actually be removed, since the game should start with no level loaded (in the menu)

@onready var currentLevelNode = $"CurrentLevelContent/Level"
# for the floor checking later,  this is neeeded to not fall down holes you just climbed up
var justChangedFloors = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$BGMPlayer.stream = load("res://Sound/ghostMain.wav")
	$BGMPlayer.play()
	#$"CurrentLevelContent/Level/Floor B".visible = false
	#this itemmap will have to be called dynamically once we have more levels
	character.Done_Moving.connect(_on_character_done_moving)
	#testInit()
	main_menu.disabled = false
	character.in_menu = true
	in_main_menu = true
	$CurrentLevelContent.visible = false
	$floor_ui.visible = false
	$TutorialText.visible = false
	
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("menu_action") and character.moving == false and not(in_main_menu):
		if(in_menu):
			in_menu = false
			# Hide and unhide the correct floors based on where character was before
			for i in currentLevelNode.floorOrder:
				if i == current_floor_node:
					i.visible = true
				else:
					i.visible = false
			character.visible = true
		else:
			await get_tree().create_timer(0.4).timeout
			in_menu = true
			character.visible = false
			# saved so you can go back to it later when the menu is closed
			current_floor_node = currentLevelNode.floorOrder[current_floor]
			current_floor_letter = current_floor_node.name.rsplit(" ",1)[1]
			print(current_floor_letter)
	if Input.is_action_just_pressed("reset") and not(in_main_menu) and not(in_menu):
		loadLevel(currentLevel,true)
	if in_menu:
		for i in $floor_ui.currentFloorOrder:
			if i[4]:
				currentLevelNode.find_child("Floor "+ str(i[0])).visible = true
				if i[0] == current_floor_letter:
					character.visible = true
				else:
					character.visible = false
			else:
				currentLevelNode.find_child("Floor "+ str(i[0])).visible = false
	if Input.is_action_just_pressed("credits") and in_main_menu:
		$Credits.visible = not($Credits.visible)
		main_menu.visible = not(main_menu.visible)
		main_menu.disabled = not(main_menu.disabled)
	elif Input.is_action_just_pressed("menu_action") and $Credits.visible:
		$Credits.visible = not($Credits.visible)
		main_menu.visible = not(main_menu.visible)
		main_menu.disabled = not(main_menu.disabled)
func changeFloors(tileName, goUp:bool):
	var floorDelta:int # -1 or 1
	# the change in floor when this (hypothetical) action is complete
	if goUp:
		floorDelta = -1
	else:
		floorDelta = 1
	#if justChangedFloors:
		#justChangedFloors = false
	#else:
	if true:
		if (current_floor + floorDelta >= 0 and goUp) or (current_floor + floorDelta < currentLevelNode.floorOrder.size() and not(goUp)):
			var floorNext = currentLevelNode.floorOrder[current_floor+floorDelta]
			# basically checking the floor above / below actually exists
			var deltaItemTile # the tile on the "items" map on the delta floor (ex: a ladder below a hole)
			if floorNext.find_child("Items").get_cell_tile_data(item_map.local_to_map(character.position)) != null:
				deltaItemTile = floorNext.find_child("Items").get_cell_tile_data(item_map.local_to_map(character.position)).get_custom_data("Name")
			else:
				deltaItemTile = ""
			#print(deltaItemTile)
			if (tileName == "ladder" and (deltaItemTile == "hole" or deltaItemTile == "trapdoorOpen")) or (tileName == "trapdoorOpen" and (deltaItemTile== "ladder")) or (tileName == "hole"):
				currentLevelNode.floorOrder[current_floor].visible = false
				floorNext.visible = true
				item_map = floorNext.find_child("Items")
				$floor_ui.currentFloorOrder[current_floor][1] = false
				current_floor += floorDelta
				$floor_ui.currentFloorOrder[current_floor][1] = true
				if deltaItemTile == "hole" and tileName=="hole":
					changeFloors("hole",false)
				# if the thing you just traveled through is a hole, don't block the next itemcheck (because there won't be one below)
				justChangedFloors = not((deltaItemTile == "" or deltaItemTile=="hole") and tileName == "hole")
	

func _on_character_detected_item() -> void:
	# BTW this function isn't called on detected items anymore, it's when the character moves
	var tile_name
	#print(currentLevelNode.floorOrder)
	#print(current_floor)
	if item_map.get_cell_tile_data(item_map.local_to_map(character.position)) != null:
		tile_name = item_map.get_cell_tile_data(item_map.local_to_map(character.position)).get_custom_data("Name")
	else:
		tile_name = ""

	# everything past here is to be condensed 
	if tile_name == "ladder":
		changeFloors("ladder",true)
	elif tile_name == "hole":
		changeFloors("hole",false)
	elif tile_name == "trapdoorOpen":
		changeFloors("trapdoorOpen",false)
	elif tile_name == "key":
		item_map.set_cell(item_map.local_to_map(character.position), current_tile_set_id,  Vector2(-1,-1))
		for i in $floor_ui.currentFloorOrder:
			if i[3] == true:
				i[3] = false
				break
	elif tile_name == "exit":
		currentLevel+=1
		loadLevel(currentLevel)
	elif tile_name == "broken1":
		if current_floor + 1 == currentLevelNode.floorOrder.size():
			item_map.set_cell(item_map.local_to_map(character.position), current_tile_set_id,  ground_broken_2_coord)
		else:
			item_map.set_cell(item_map.local_to_map(character.position), current_tile_set_id,  broken_2_coord)
		
#func testInit():
	## in future this will be handled by the level picker in the menu
	## Hence the title TESTinit
	#loadLevel(1)

func loadMainMenu():
	$BGMPlayer.stream = load("res://Sound/ghostMain.wav")
	$BGMPlayer.play()
	main_menu.queue_free()
	main_menu = load("res://Main_menu_stuff/main_menu.tscn").instantiate()
	self.add_child(main_menu)
	$Credits.move_to_front()
	main_menu.disabled = false
	main_menu.connect("loadLevel",loadLevel,1)
	character.in_menu = true
	in_main_menu = true
	$CurrentLevelContent.visible = false
	$floor_ui.visible = false
	$TutorialText.visible = false

func loadLevel(level:int,resetMode:bool=false):
	if level > main_menu.numberOfLevels:
		loadMainMenu()
	else:
		$Credits.visible = false
		main_menu.disabled = true
		character.in_menu = false
		in_main_menu = false
		$CurrentLevelContent.visible = true
		$TutorialText.visible = true
		currentLevel = level
		currentLevelNode.queue_free()
		# testing loading personal levels
		var nextLevelNode
		if level == 1:
			nextLevelNode = load("res://kristylevels/level_6.tscn").instantiate()
		else:
			nextLevelNode = load("res://Levels/level_"+str(currentLevel)+".tscn").instantiate()
		#testing ends here MAKE SURE TO REVERT THIS PART
		nextLevelNode.name = "Level"
		# this sets currentLevelNode to nextLevelNode, but they're both used after this point
		currentLevelNode = nextLevelNode
		$CurrentLevelContent.add_child(nextLevelNode)
		character.move_to_front()
		# 2 is the default scale for currentLevelContent (For some reason)
		$CurrentLevelContent.scale = currentLevelNode.scaleForMainScene*Vector2(2,2)
		#character.position = Vector2(24,24)
		character.setPosition(16*currentLevelNode.starting_tile + Vector2i(8,8))
		character.visible = true
		var listForFloorUI = []
		for i in nextLevelNode.floorOrder:
			var playerOn = false
			var exitOn = false
			var locked = false
			if i == nextLevelNode.startingFloor:
				playerOn = true
			if i == nextLevelNode.exitFloor:
				exitOn = true
			if i.locked == true:
				locked = true
			listForFloorUI.append([str(i.name)[-1],playerOn,exitOn,locked,false])
		$floor_ui.currentFloorOrder = listForFloorUI
		$floor_ui.visible = true
		current_floor = currentLevelNode.floorOrder.find(currentLevelNode.startingFloor)
		item_map = currentLevelNode.startingFloor.find_child("Items")
		$TutorialText.loadLevelTutorial(level,1)
		character.levelSize = currentLevelNode.scaleForMainScene
		update_item_tiles()
		SaveHandler.unlockCheck(level)
		if not(resetMode):
			var prevSong = $BGMPlayer.stream
			$BGMPlayer.stop()
			while $BGMPlayer.stream == prevSong:
				$BGMPlayer.stream = levelSongs[randi() % levelSongs.size()]
			$BGMPlayer.play()
	
	var tilemap = currentLevelNode.get_node("Floor A/Wall")
	var used_rect = tilemap.get_used_rect()
	var tile_size = tilemap.tile_set.tile_size
	var center_tile = Vector2(used_rect.position) + Vector2(used_rect.size) / 2.0
	var center_world = (center_tile * Vector2(tile_size)) + tilemap.position  # Converts tile coords to world (local)
	var center_global = tilemap.to_global(center_world)  # Converts local to global position
	emit_signal("get_center", center_global)

func _on_floor_ui_menu_close(order) -> void:
	var tempOrder = []
	for i in order:
		if (i[1]):
			current_floor = order.find(i)
		tempOrder.append(currentLevelNode.find_child("Floor " + i[0]))
	currentLevelNode.floorOrder = tempOrder
	#keeps track of the floor num of the iteration, to keep track of above and below
	update_item_tiles()
		
func update_item_tiles() -> void:
	#keeps track of the floor num of the iteration, to keep track of above and below
	var iterate_floor_num = 0
	for floor in currentLevelNode.floorOrder:
		#iterating through all of the coordinates that have a item in the layer in floor
		var current_item_map = floor.find_child("Items")
		for tile_coord in current_item_map.get_used_cells():
			
			#If the item is a trapdoor, check if there is a floor under, check if it contains an item at the coord, and if its a ladder, change to open trap 
			if(current_item_map.get_cell_tile_data(tile_coord).get_custom_data("Name") == "trapdoorClosed"):
				
				#check if there is floor below
				if(currentLevelNode.floorOrder.size() > iterate_floor_num+1):
					# check if contains an item
					if(currentLevelNode.floorOrder[iterate_floor_num+1].find_child("Items").get_cell_tile_data(tile_coord) != null):
						#check if its a ladder
						var item_below  = currentLevelNode.floorOrder[iterate_floor_num+1].find_child("Items").get_cell_tile_data(tile_coord).get_custom_data("Name")
						if(item_below == "ladder" || item_below == "ladderGrey"):
							#Setting to coord in tile map MUST BE CHANGED IF TILE MAP IS CHANGED!!!!!!
							current_item_map.set_cell(tile_coord, current_tile_set_id,  trapdoor_open_coord)
			if(current_item_map.get_cell_tile_data(tile_coord).get_custom_data("Name") == "trapdoorOpen"):
				#check if there is floor below, if there isnt, close the trapdoor
				if(currentLevelNode.floorOrder.size() <= iterate_floor_num+1):
					current_item_map.set_cell(tile_coord, current_tile_set_id,  trapdoor_closed_coord)
				else:
					# check if contains an item, if there isnt, close the trapdoor
					if(currentLevelNode.floorOrder[iterate_floor_num+1].find_child("Items").get_cell_tile_data(tile_coord) == null):
						current_item_map.set_cell(tile_coord, current_tile_set_id,  trapdoor_closed_coord)
					else:
						if(currentLevelNode.floorOrder[iterate_floor_num+1].find_child("Items").get_cell_tile_data(tile_coord).get_custom_data("Name") != "ladder"):
							#Setting to coord in tile map MUST BE CHANGED IF TILE MAP IS CHANGED!!!!!!
							current_item_map.set_cell(tile_coord, current_tile_set_id,  trapdoor_closed_coord)
			#Changing ladder to ladderGrey
			if(current_item_map.get_cell_tile_data(tile_coord).get_custom_data("Name") == "ladder" && current_item_map.get_cell_tile_data(tile_coord).get_custom_data("LadderType") == 0 ):
				if(iterate_floor_num > 0):
					if(currentLevelNode.floorOrder[iterate_floor_num-1].find_child("Items").get_cell_tile_data(tile_coord) != null):
						var item_above = currentLevelNode.floorOrder[iterate_floor_num-1].find_child("Items").get_cell_tile_data(tile_coord).get_custom_data("Name")
						if(item_above == "hole" || item_above == "trapdoorOpen" || item_above == "trapdoorClosed"):
							current_item_map.set_cell(tile_coord, current_tile_set_id,  ladder_grey_coord)
									
							continue
			#changing grey ladders to regular ladders
			if(current_item_map.get_cell_tile_data(tile_coord).get_custom_data("Name") == "ladder" && current_item_map.get_cell_tile_data(tile_coord).get_custom_data("LadderType") == 1 ):
				if(iterate_floor_num == 0):
					current_item_map.set_cell(tile_coord, current_tile_set_id,  ladder_coord)
				else:
					if(currentLevelNode.floorOrder[iterate_floor_num-1].find_child("Items").get_cell_tile_data(tile_coord) == null):
						current_item_map.set_cell(tile_coord, current_tile_set_id,  ladder_coord)
					else:
						var item_above = currentLevelNode.floorOrder[iterate_floor_num-1].find_child("Items").get_cell_tile_data(tile_coord).get_custom_data("Name")
						if(item_above != "hole" or item_above != "trapdoorOpen" or item_above != "trapdoorClosed" ):
							current_item_map.set_cell(tile_coord, current_tile_set_id,  ladder_coord)
			#changing holes if they are on the ground floor and checking for ladders 
			if (current_item_map.get_cell_tile_data(tile_coord).get_custom_data("Name") == "hole" && iterate_floor_num + 1 == currentLevelNode.floorOrder.size()):
				#checking if the hole type is a non broken one
				if(current_item_map.get_cell_tile_data(tile_coord).get_custom_data("HoleType") == 0 || current_item_map.get_cell_tile_data(tile_coord).get_custom_data("HoleType") == 1):
					current_item_map.set_cell(tile_coord, current_tile_set_id, ground_hole_coord)
				if(current_item_map.get_cell_tile_data(tile_coord).get_custom_data("HoleType") == 2 || current_item_map.get_cell_tile_data(tile_coord).get_custom_data("HoleType") == 3):
					current_item_map.set_cell(tile_coord, current_tile_set_id, ground_broken_hole_coord)
				
			if(current_item_map.get_cell_tile_data(tile_coord).get_custom_data("Name") == "groundHole" && iterate_floor_num + 1 != currentLevelNode.floorOrder.size()):
				if(current_item_map.get_cell_tile_data(tile_coord).get_custom_data("HoleType") == 0):
					current_item_map.set_cell(tile_coord, current_tile_set_id, hole_coord)
				if(current_item_map.get_cell_tile_data(tile_coord).get_custom_data("HoleType") == 2):
					current_item_map.set_cell(tile_coord, current_tile_set_id, broken_hole_coord)
			#chekcing for ladders to put in holes/ dont need to check for floor below, as all holes will be not on the bottom floor
			if (current_item_map.get_cell_tile_data(tile_coord).get_custom_data("Name") == "hole"):
				if(currentLevelNode.floorOrder[iterate_floor_num+1].find_child("Items").get_cell_tile_data(tile_coord) != null):
					#check if its a ladder
					var item_below  = currentLevelNode.floorOrder[iterate_floor_num+1].find_child("Items").get_cell_tile_data(tile_coord).get_custom_data("Name")
					if(item_below == "ladder" || item_below == "ladderGrey"):
						#Setting to coord in tile map MUST BE CHANGED IF TILE MAP IS CHANGED!!!!!!
						if(current_item_map.get_cell_tile_data(tile_coord).get_custom_data("HoleType") == 0 || current_item_map.get_cell_tile_data(tile_coord).get_custom_data("HoleType") == 1 ):
							current_item_map.set_cell(tile_coord, current_tile_set_id, hole_ladder_coord)
						if(current_item_map.get_cell_tile_data(tile_coord).get_custom_data("HoleType") == 2 || current_item_map.get_cell_tile_data(tile_coord).get_custom_data("HoleType") == 3 ):
							current_item_map.set_cell(tile_coord, current_tile_set_id, broken_hole_ladder_coord)
					else:
						if(current_item_map.get_cell_tile_data(tile_coord).get_custom_data("HoleType") == 0 || current_item_map.get_cell_tile_data(tile_coord).get_custom_data("HoleType") == 1 ):
							current_item_map.set_cell(tile_coord, current_tile_set_id, hole_coord)
						if(current_item_map.get_cell_tile_data(tile_coord).get_custom_data("HoleType") == 2 || current_item_map.get_cell_tile_data(tile_coord).get_custom_data("HoleType") == 3 ):
							current_item_map.set_cell(tile_coord, current_tile_set_id, broken_hole_coord)
				else:
					if(current_item_map.get_cell_tile_data(tile_coord).get_custom_data("HoleType") == 0 || current_item_map.get_cell_tile_data(tile_coord).get_custom_data("HoleType") == 1 ):
						current_item_map.set_cell(tile_coord, current_tile_set_id, hole_coord)
					if(current_item_map.get_cell_tile_data(tile_coord).get_custom_data("HoleType") == 2 || current_item_map.get_cell_tile_data(tile_coord).get_custom_data("HoleType") == 3 ):
							current_item_map.set_cell(tile_coord, current_tile_set_id, broken_hole_coord)
		iterate_floor_num += 1
		
func _on_character_done_moving() -> void:
	#checking for tiles that need to be broken
	if not(in_main_menu):
		for tile_coord in item_map.get_used_cells():
			if(item_map.get_cell_tile_data(tile_coord).get_custom_data("Name") == "broken2"):
				item_map.set_cell(tile_coord, current_tile_set_id,  broken_hole_coord)
			if (item_map.get_cell_tile_data(tile_coord).get_custom_data("Name") == "groundBroken2"):
				item_map.set_cell(tile_coord, current_tile_set_id,  ground_broken_hole_coord)

func _on_main_menu_load_level(level: int) -> void:
	loadLevel(level)
