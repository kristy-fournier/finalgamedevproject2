extends Node
var item_map
var character
var current_floor
var floors

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"CurrentLevelContent/Level/Floor B".visible = false
	item_map = $"CurrentLevelContent/Level/Floor A/Items"
	character = $"CurrentLevelContent/Character"
	
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	testInit()


func _on_character_detected_item() -> void:
	var tile_name = item_map.get_cell_tile_data(item_map.local_to_map(character.position)).get_custom_data("Name")
	print(character.position)
	if tile_name == "ladderUp":
		#$"CurrentLevelContent/Level1/Floor A".visible = false
		#$"CurrentLevelContent/Level1/Floor B".visible = true
		if $CurrentLevelContent/Level.floorOrder[current_floor-1] != null:
			var floorAbove = $CurrentLevelContent/Level.floorOrder[current_floor-1].get_child("Items")
			if floorAbove.get_cell_tile_data(item_map.local_to_map(character.position)) != null:
				var aboveItemTile = floorAbove.get_cell_tile_data(item_map.local_to_map(character.position)).get_custom_data("Name")
				if aboveItemTile == "hole":
					$CurrentLevelContent/Level.floorOrder[current_floor].visible = false
					floorAbove.visible = true
	if tile_name == "hole":
		pass
		#check if just climbed up ladder. 
		#emit change floor
		#change itemmap to destination floor
	if tile_name == "exit":
		$"CurrentLevelContent/Level1".delete() 
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
		tempOrder.append($"CurrentLevelContent/Level".get_children().find("Floor " + i[0]))
	$"CurrentLevelContent/Level".floorOrder = tempOrder
