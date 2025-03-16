extends Node
var item_map
var character
var current_floor
var floors
var in_menu = false
# for the floor checking later,  this is neeeded to not fall down holes you just climbed up
var justChangedFloors = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"CurrentLevelContent/Level/Floor B".visible = false
	#this itemmap will have to be called dynamically once we have more levels
	item_map = $"CurrentLevelContent/Level/Floor A/Items"
	character = $"CurrentLevelContent/Character"
	testInit()
	
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("menu_action"):
		if(in_menu):
			$floor_ui.scale = Vector2(0.6,0.6)
			$floor_ui.position= Vector2(331,27)
			in_menu = false
		else:
			$floor_ui.scale = Vector2(0.8,0.8)
			$floor_ui.position= Vector2(175,27)
			in_menu = true


func _on_character_detected_item() -> void:
	var tile_name
	print($CurrentLevelContent/Level.floorOrder)
	if item_map.get_cell_tile_data(item_map.local_to_map(character.position)) != null:
		tile_name = item_map.get_cell_tile_data(item_map.local_to_map(character.position)).get_custom_data("Name")
	else:
		tile_name = ""
	print(character.position)
	if tile_name == "ladderUp":

		if justChangedFloors:
			justChangedFloors = false
		else:
			# Basically this giant block checks for nulls and for holes (and trapdoors in future) on the floor above to see if you can go up or not
			# it absolutely needs to be optimised but thats for monday/ next week
			if $CurrentLevelContent/Level.floorOrder[current_floor-1] != null:
				var floorAbove = $CurrentLevelContent/Level.floorOrder[current_floor-1]
				# basically checking the floor above actually exists and has a tilemap
				print(floorAbove)
				if floorAbove.find_child("Items").get_cell_tile_data(item_map.local_to_map(character.position)) != null:
					var aboveItemTile = floorAbove.find_child("Items").get_cell_tile_data(item_map.local_to_map(character.position)).get_custom_data("Name")
					print(aboveItemTile)
					if aboveItemTile == "hole":
						$CurrentLevelContent/Level.floorOrder[current_floor].visible = false
						floorAbove.visible = true
						item_map = floorAbove.find_child("Items")
						justChangedFloors = true
						$floor_ui.currentFloorOrder[current_floor][1] = false
						current_floor-=1
						$floor_ui.currentFloorOrder[current_floor][1] = true
	if tile_name == "hole":
		#check if just climbed up ladder. 
		if justChangedFloors:
			justChangedFloors = false
		else:
			if $CurrentLevelContent/Level.floorOrder.size() > current_floor+1:
				if $CurrentLevelContent/Level.floorOrder[current_floor+1] != null:
					var floorBelow = $CurrentLevelContent/Level.floorOrder[current_floor+1]
					# basically checking the floor above actually exists and has a tilemap
					if floorBelow.find_child("Items").get_cell_tile_data(item_map.local_to_map(character.position)) != null:
						#no need to check the tile below for falling (falling is always allowed)
						$CurrentLevelContent/Level.floorOrder[current_floor].visible = false
						floorBelow.visible = true
						item_map = floorBelow.find_child("Items")
						$floor_ui.currentFloorOrder[current_floor][1] = false
						current_floor+=1
						$floor_ui.currentFloorOrder[current_floor][1] = true
						justChangedFloors = true
	
			#emit change floor
			#change itemmap to destination floor
	if tile_name == "exit":
		
		#$"CurrentLevelContent/Level".queue_free()
		pass
		
		
func testInit():
	#initialise level 1 for our submission on monday
	$floor_ui.currentFloorOrder = [["A", true, false, false, false], ["B", false, true, false, false]]
	current_floor = 0


func _on_floor_ui_menu_close(order) -> void:
	var tempOrder = []
	for i in order:
		if (i[1]):
			current_floor = order.find(i)
		tempOrder.append($"CurrentLevelContent/Level".find_child("Floor " + i[0]))
	$"CurrentLevelContent/Level".floorOrder = tempOrder
