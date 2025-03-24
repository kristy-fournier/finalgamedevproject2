extends Node
var item_map
var character
var current_floor
var in_menu = false
var currentLevel

#MUST BE CHANGED IF ANY CHANGES TO TILE SET HAPPEN
const current_tile_set_id = 0
const trapdoor_open_coord = Vector2(2,0)
const trapdoor_closed_coord = Vector2(1,0)

# this line below should actually be removed, since the game should start with no level loaded (in the menu)
@onready var currentLevelNode = $"CurrentLevelContent/Level"
# for the floor checking later,  this is neeeded to not fall down holes you just climbed up
var justChangedFloors = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$"CurrentLevelContent/Level/Floor B".visible = false
	#this itemmap will have to be called dynamically once we have more levels
	character = $"CurrentLevelContent/Character"
	testInit()
	
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("menu_action"):
		if(in_menu):
			in_menu = false
		else:
			in_menu = true
	if in_menu:
		character.visible = false
		

func changeFloors(tileName, goUp:bool):
	var floorDelta:int # -1 or 1
	# the change in floor when this (hypothetical) action is complete
	if goUp:
		floorDelta = -1
	else:
		floorDelta = 1
	if justChangedFloors:
		justChangedFloors = false
	else:
		if (current_floor + floorDelta >= 0 and goUp) or (current_floor + floorDelta < currentLevelNode.floorOrder.size() and not(goUp)):
			var floorNext = currentLevelNode.floorOrder[current_floor+floorDelta]
			# basically checking the floor above / below actually exists
			var deltaItemTile # the tile on the "items" map on the delta floor (ex: a ladder below a hole)
			if floorNext.find_child("Items").get_cell_tile_data(item_map.local_to_map(character.position)) != null:
				deltaItemTile = floorNext.find_child("Items").get_cell_tile_data(item_map.local_to_map(character.position)).get_custom_data("Name")
			else:
				deltaItemTile = ""
			print(deltaItemTile)
			if (tileName == "ladder" and (deltaItemTile == "hole" or deltaItemTile == "trapdoorOpen")) or (tileName == "trapdoorOpen" and (deltaItemTile== "ladder")) or (tileName == "hole"):
				currentLevelNode.floorOrder[current_floor].visible = false
				floorNext.visible = true
				item_map = floorNext.find_child("Items")
				$floor_ui.currentFloorOrder[current_floor][1] = false
				current_floor += floorDelta
				$floor_ui.currentFloorOrder[current_floor][1] = true
				# if the thing you just traveled through is a hole, don't block the next itemcheck (because there won't be one below)
				justChangedFloors = not((deltaItemTile == "" or deltaItemTile=="hole") and tileName == "hole")
	

func _on_character_detected_item() -> void:
	var tile_name
	#print(currentLevelNode.floorOrder)
	#print(current_floor)
	if item_map.get_cell_tile_data(item_map.local_to_map(character.position)) != null:
		tile_name = item_map.get_cell_tile_data(item_map.local_to_map(character.position)).get_custom_data("Name")
	else:
		tile_name = ""
	if tile_name == "ladder":
		changeFloors("ladder",true)
	elif tile_name == "hole":
		changeFloors("hole",false)
	elif tile_name == "trapdoorOpen":
		changeFloors("trapdoorOpen",false)
	elif tile_name == "key":
		for i in $floor_ui.currentFloorOrder:
			if i[3] == true:
				i[3] = false
				break
	if tile_name == "exit":
		currentLevel+=1
		loadLevel(currentLevel)
		
func testInit():
	# in future this will be handled by the level picker in the menu
	# Hence the title TESTinit
	loadLevel(1)

func loadLevel(level:int):
	currentLevel = level
	currentLevelNode.queue_free()
	var nextLevelNode = load("res://level_"+str(currentLevel)+".tscn").instantiate()
	nextLevelNode.name = "Level"
	currentLevelNode = nextLevelNode
	$CurrentLevelContent.add_child(nextLevelNode)
	character.move_to_front()
	#character.position = Vector2(24,24)
	character.position = 16 * currentLevelNode.starting_tile + Vector2i(8,8)
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
	current_floor = currentLevelNode.floorOrder.find(currentLevelNode.startingFloor)
	item_map = currentLevelNode.startingFloor.find_child("Items")
	update_item_tiles()

func _on_floor_ui_menu_close(order) -> void:
	var tempOrder = []
	for i in order:
		if (i[1]):
			current_floor = order.find(i)
		tempOrder.append(currentLevelNode.find_child("Floor " + i[0]))
	currentLevelNode.floorOrder = tempOrder
	#keeps track of the floor num of the iteration, to keep track of above and below
	update_item_tiles()
		
func update_item_tiles() ->void:
	#keeps track of the floor num of the iteration, to keep track of above and below
	var iterate_floor_num = 0
	for floor in currentLevelNode.floorOrder:
		#iterating through all of the coordinates that have a item in the layer in floor
		var current_item_map = floor.find_child("Items")
		for tile_coord in current_item_map.get_used_cells():
			#print(tile_coord)
			#If the item is a trapdoor, check if there is a floor under, check if it contains an item at the coord, and if its a ladder, change to open trap 
			if(current_item_map.get_cell_tile_data(tile_coord).get_custom_data("Name") == "trapdoorClosed"):
				#check if there is floor below
				if(currentLevelNode.floorOrder.size() > iterate_floor_num+1):
					# check if contains an item
					if(currentLevelNode.floorOrder[iterate_floor_num+1].find_child("Items").get_cell_tile_data(tile_coord) != null):
						#check if its a ladder
						if(currentLevelNode.floorOrder[iterate_floor_num+1].find_child("Items").get_cell_tile_data(tile_coord).get_custom_data("Name") == "ladder"):
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
		iterate_floor_num += 1
	
