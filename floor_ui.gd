extends Node2D

#In the floorUI scene, each level is represented as a 2D list that only contains key information about that level
#Each floor is a list (as an element of another list) that should represent: 
#[String: Floor Letter, Boolean: Player is on floor, Boolean: Goal is on floor, Boolean: Floor is locked, Boolean: Floor is selected]
var currentFloorOrder = [["C", true, true, false, false], ["B", false, false, false, false], ["A", false, false, false, false], ["D", false, false, true, false]]
var menuMode = false
var swapMode = false
var viewport_size = get_viewport_rect().size  # Get the viewport size
var orgPos = null
signal menu_close(Order)

func _ready():
	get_node("shadow").hide()
	orgPos = self.position #keep track of the original position

func _process(delta):
	
	if Input.is_action_just_pressed("menu_action"):
		toggleMenu()
		
	#When menuMode == true, this function allows the player to select the floors
	if(menuMode == true):

		if(swapMode == false):

			if Input.is_action_just_pressed("move_up"):
				if(currentFloorOrder[0][4] == true):
					currentFloorOrder[0][4] = false
					#Check if the above floor (in this case bottom floor) is a locked floor. If so, 'skip over' it.
					if(currentFloorOrder[len(currentFloorOrder) - 1][3] == true):
						currentFloorOrder[len(currentFloorOrder) - 2][4] = true
					else:
						currentFloorOrder[len(currentFloorOrder) - 1][4] = true
					
				else:
					for i in range(0, len(currentFloorOrder), 1):
						if(currentFloorOrder[i][4] == true):
							currentFloorOrder[i][4] = false
							#Check if the above floor is a locked floor. If so, 'skip over' it.
							if(currentFloorOrder[i - 1][3] == true):
								currentFloorOrder[i - 2][4] = true
							else:
								currentFloorOrder[i - 1][4] = true
							break

			if Input.is_action_just_pressed("move_down"):
				if(currentFloorOrder[len(currentFloorOrder) - 1][4] == true):
					currentFloorOrder[len(currentFloorOrder) - 1][4] = false
					#Check if the floor below (in this case the top floor) is a locked floor. If so, 'skip over' it.
					if(currentFloorOrder[0][3] == true):
						currentFloorOrder[1][4] = true
					else:
						currentFloorOrder[0][4] = true

				else:
					for i in range(0, len(currentFloorOrder), 1):
						if(currentFloorOrder[i][4] == true):
							currentFloorOrder[i][4] = false
							#Check if the floor below is a locked floor. If so, 'skip over' it.
							#extra check if the locked floor is at the bottom because when when using .pop() the list gets shorter which may cause an error
							if((currentFloorOrder[i + 1][3] == true) and (i + 1 == len(currentFloorOrder)-1)):
								currentFloorOrder[0][4] = true
							elif(currentFloorOrder[i + 1][3] == true):
								currentFloorOrder[i + 2][4] = true
							else:
								currentFloorOrder[i + 1][4] = true
							break

		if(swapMode == true):
			
			if Input.is_action_just_pressed("move_up"):
				for i in range(0, len(currentFloorOrder), 1):
					if(currentFloorOrder[i][4] == true):
						moveFloorUp(currentFloorOrder, i)
						break
			
			if Input.is_action_just_pressed("move_down"):
				for i in range(0, len(currentFloorOrder), 1):
					if(currentFloorOrder[i][4] == true):
						moveFloorDown(currentFloorOrder, i)
						break

		if Input.is_action_just_pressed("interact"): #might need to change this, if a new input map was created while I was working independantly on this.
			if (swapMode == false):
				swapMode = true
			else:
				swapMode = false

func toggleMenu():
	if(menuMode == true):
		#self.scale = Vector2(1, 1)
		#self.position = orgPos
		get_node("machine").turn_off()
		menuMode = false
		swapMode = false
		for i in range(0, len(currentFloorOrder), 1):
			currentFloorOrder[i][4] = false
		menu_close.emit(currentFloorOrder)
	elif(menuMode == false):
		#Change Scale and Position Here
		menuMode = true
		swapMode = false
		get_node("machine").turn_on() 
		currentFloorOrder[0][4] = true
		

func moveFloorUp(floorOrder: Array, index: int):
	if(floorOrder[index][3] == true):
		print('Error from floor.ui.gd: Cannot move a locked floor')
		return null
	#swap it with the closest unlocked floor above it. (ex: [2, 1, A, 4, 3])
	#                                                        0, 1, 2, -2 -1 
	var closestUnlockedFloorIndex = null
	for i in range(1, len(floorOrder)+1, 1):
		if(floorOrder[index - i][3] == true):
			continue
		else:
			closestUnlockedFloorIndex = index - i
			break
	var temp = floorOrder[index]
	floorOrder[index] = floorOrder[closestUnlockedFloorIndex]
	floorOrder[closestUnlockedFloorIndex] = temp

#instead of writing a new function that searches for the closest element to the left of A, instead we can search for the farthest element and use the same code.
func moveFloorDown(floorOrder: Array, index: int):
	if(floorOrder[index][3] == true):
		print('Error from floor.ui.gd: Cannot move a locked floor')
		return null
	#swap it with the closest unlocked floor above it. (ex: [2, 1, A, 4, 3])
	#                                                        0, 1, 2, -2 -1 
	var farthestUnlockedFloorIndex = 0
	for i in range(0, len(floorOrder), 1): 
		if(floorOrder[index - i][3] == true):
			continue
		else:
			farthestUnlockedFloorIndex = index - i
			#no break because in this case we want to take the farthest floor not the closest
	var temp = floorOrder[index]
	floorOrder[index] = floorOrder[farthestUnlockedFloorIndex]
	floorOrder[farthestUnlockedFloorIndex] = temp

func _on_main_scene_get_center(center: Vector2) -> void:
	get_node("machine").Lvlcenter = center
