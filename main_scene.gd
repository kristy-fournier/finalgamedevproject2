extends Node
var item_map
var character


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"CurrentLevelContent/Level1/Floor B".visible = false
	item_map = $"CurrentLevelContent/Level1/Floor A/Items"
	character = $"CurrentLevelContent/Character"
	
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_character_detected_item() -> void:
	var tile_name = item_map.get_cell_tile_data(item_map.local_to_map(character.position)).get_custom_data("Name")
	print(character.position)
	if tile_name == "ladderUp":
		$"CurrentLevelContent/Level1/Floor A".visible = false
		$"CurrentLevelContent/Level1/Floor B".visible = true
		item_map = $"CurrentLevelContent/Level1/Floor B/Items"
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
	
