extends Node
var item_map
var character
var current_floor
var in_menu = false
var currentLevel = 1
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
			# basically checking the floor above actually exists and has a tilemap
			var deltaItemTile # the tile on the "items" map on the delta floor (ex: a ladder below a hole)
			if floorNext.find_child("Items").get_cell_tile_data(item_map.local_to_map(character.position)) != null:
				deltaItemTile = floorNext.find_child("Items").get_cell_tile_data(item_map.local_to_map(character.position)).get_custom_data("Name")
			else:
				deltaItemTile = ""
			print(deltaItemTile)
			if (tileName == "ladder" and (deltaItemTile == "hole" or deltaItemTile == "trapdoor")) or (tileName == "trapdoor" and (deltaItemTile== "ladder")) or (tileName == "hole"):
			#if true:
				# If you're on a build with tile changing swap the if statements above
				# it'll just only collide with functional tiles b
				currentLevelNode.floorOrder[current_floor].visible = false
				floorNext.visible = true
				item_map = floorNext.find_child("Items")
				$floor_ui.currentFloorOrder[current_floor][1] = false
				current_floor += floorDelta
				$floor_ui.currentFloorOrder[current_floor][1] = true
				# if the thing you just traveled through is a hole, don't block the next itemcheck (because there won't be one below)
				justChangedFloors = not(deltaItemTile == "" and tileName == "hole")
	

func _on_character_detected_item() -> void:
	var tile_name
	print(currentLevelNode.floorOrder)
	print(current_floor)
	if item_map.get_cell_tile_data(item_map.local_to_map(character.position)) != null:
		tile_name = item_map.get_cell_tile_data(item_map.local_to_map(character.position)).get_custom_data("Name")
	else:
		tile_name = ""
	# everything past here is to be condensed 
	if tile_name == "ladder":
		changeFloors("ladder",true)
	if tile_name == "hole":
		changeFloors("hole",false)
	if tile_name == "trapdoor":
		changeFloors("trapdoor",false)
	if tile_name == "exit":
		nextLevel()
		
func testInit():
	#initialise level 1 for our submission on monday
	$floor_ui.currentFloorOrder = [["A", true, false, false, false], ["B", false, true, false, false]]
	item_map = currentLevelNode.startingFloor.find_child("Items")
	current_floor = 0

func nextLevel():
	currentLevel += 1
	currentLevelNode.queue_free()
	var nextLevelNode = load("res://level_"+str(currentLevel)+".tscn").instantiate()
	nextLevelNode.name = "Level"
	currentLevelNode = nextLevelNode
	$CurrentLevelContent.add_child(nextLevelNode)
	character.move_to_front()
	character.position = Vector2(24,24)
	var listForFloorUI = []
	for i in nextLevelNode.floorOrder:
		var playerOn = false
		var exitOn = false
		if i == nextLevelNode.startingFloor:
			playerOn = true
		if i == nextLevelNode.exitFloor:
			exitOn = true
		listForFloorUI.append([str(i.name)[-1],playerOn,exitOn,false,false])
	$floor_ui.currentFloorOrder = listForFloorUI
	current_floor = currentLevelNode.floorOrder.find(currentLevelNode.startingFloor)
	item_map = currentLevelNode.startingFloor.find_child("Items")

func _on_floor_ui_menu_close(order) -> void:
	var tempOrder = []
	for i in order:
		if (i[1]):
			current_floor = order.find(i)
		tempOrder.append(currentLevelNode.find_child("Floor " + i[0]))
	currentLevelNode.floorOrder = tempOrder
