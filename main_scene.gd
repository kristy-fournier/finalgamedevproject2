extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var tilemap = $"CurrentLevelContent/Level1/Floor A/Wall"
	var character = $CurrentLevelContent/Character
	if tilemap.get_cell_tile_data(tilemap.local_to_map(character.position)) != null:
		if tilemap.get_cell_tile_data(tilemap.local_to_map(character.position)).get_custom_data("Name") == "wall":
			character.position = character.lastPosition
	var itemmap = $"CurrentLevelContent/Level1/Floor A/Items"
	if itemmap.get_cell_tile_data(itemmap.local_to_map(character.position)) != null:
		if itemmap.get_cell_tile_data(itemmap.local_to_map(character.position)).get_custom_data("Name") == "ladderUp":
			$"CurrentLevelContent/Level1/Floor A".visible = false
			$"CurrentLevelContent/Level1/Floor B".visible = true
			
