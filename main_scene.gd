extends Node
var item_map
var character
var current_floor
var floors
var in_menu = false
var currentLevel = 1
@onready var currentLevelNode = $"CurrentLevelContent/Level"
# for the floor checking later,  this is neeeded to not fall down holes you just climbed up
var went_up_a_floor = false
var went_down_a_floor = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$"CurrentLevelContent/Level/Floor B".visible = false
	#this itemmap will have to be called dynamically once we have more levels
	character = $"CurrentLevelContent/Character"
	testInit()
	
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("menu_action"):
		#if(in_menu):
			##$floor_ui.scale = Vector2(0.6,0.6)
			##$floor_ui.position= Vector2(331,27)
			#in_menu = false
		#else:
			##$floor_ui.scale = Vector2(0.8,0.8)
			##$floor_ui.position= Vector2(175,27)
			#in_menu = true
	pass


func _on_character_detected_item() -> void:
	var tile_name
	print(currentLevelNode.floorOrder)
	print(current_floor)
	if item_map.get_cell_tile_data(item_map.local_to_map(character.position)) != null:
		tile_name = item_map.get_cell_tile_data(item_map.local_to_map(character.position)).get_custom_data("Name")
	else:
		tile_name = ""
	if tile_name == "ladderUp":
		if went_down_a_floor:
			went_down_a_floor = false
		else:
			# Basically this giant block checks for nulls and for holes (and trapdoors in future) on the floor above to see if you can go up or not
			# it absolutely needs to be optimised but thats for monday/ next week
			if current_floor - 1 >= 0:
				var floorAbove = currentLevelNode.floorOrder[current_floor-1]
				# basically checking the floor above actually exists and has a tilemap
				print(floorAbove)
				if floorAbove.find_child("Items").get_cell_tile_data(item_map.local_to_map(character.position)) != null:
					var aboveItemTile = floorAbove.find_child("Items").get_cell_tile_data(item_map.local_to_map(character.position)).get_custom_data("Name")
					#print(aboveItemTile)
					if aboveItemTile == "hole" or aboveItemTile == "trapdoor":
						currentLevelNode.floorOrder[current_floor].visible = false
						floorAbove.visible = true
						item_map = floorAbove.find_child("Items")
						went_up_a_floor = true
						$floor_ui.currentFloorOrder[current_floor][1] = false
						current_floor-=1
						$floor_ui.currentFloorOrder[current_floor][1] = true
	if tile_name == "hole":
		#check if just climbed up ladder. 
		if went_up_a_floor:
			went_up_a_floor = false
		else:
			if currentLevelNode.floorOrder.size() > current_floor+1:
				if currentLevelNode.floorOrder[current_floor+1] != null:
					var floorBelow = currentLevelNode.floorOrder[current_floor+1]
					# basically checking the floor above actually exists and has a tilemap
					#no need to check the tile below for falling (falling is always allowed)
					currentLevelNode.floorOrder[current_floor].visible = false
					floorBelow.visible = true
					item_map = floorBelow.find_child("Items")
					$floor_ui.currentFloorOrder[current_floor][1] = false
					current_floor+=1
					$floor_ui.currentFloorOrder[current_floor][1] = true
					went_down_a_floor = true
	if tile_name == "trapdoor":
		print("test")
		#check if just climbed up ladder. 
		if went_up_a_floor:
			went_up_a_floor = false
		else:
			if currentLevelNode.floorOrder.size() > current_floor+1:
				if currentLevelNode.floorOrder[current_floor+1] != null:
					var floorBelow = currentLevelNode.floorOrder[current_floor+1]
					# basically checking the floor above actually exists and has a tilemap
					if floorBelow.find_child("Items").get_cell_tile_data(item_map.local_to_map(character.position)) != null:
						var belowItemTile = floorBelow.find_child("Items").get_cell_tile_data(item_map.local_to_map(character.position)).get_custom_data("Name")
						print(belowItemTile)
						if belowItemTile == "ladderUp":
							currentLevelNode.floorOrder[current_floor].visible = false
							floorBelow.visible = true
							item_map = floorBelow.find_child("Items")
							$floor_ui.currentFloorOrder[current_floor][1] = false
							current_floor+=1
							$floor_ui.currentFloorOrder[current_floor][1] = true
							went_down_a_floor = true
	
			#emit change floor
			#change itemmap to destination floor
	if tile_name == "exit":
		nextLevel()
		#$"CurrentLevelContent/Level".queue_free()
		pass
		
		
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
	item_map = currentLevelNode.startingFloor.find_child("Items")

func _on_floor_ui_menu_close(order) -> void:
	var tempOrder = []
	for i in order:
		if (i[1]):
			current_floor = order.find(i)
		tempOrder.append(currentLevelNode.find_child("Floor " + i[0]))
	currentLevelNode.floorOrder = tempOrder
