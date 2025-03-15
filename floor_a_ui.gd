extends Node2D
var floorLetter = "A"

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#Every frame, we need to get the order list from the parent node.
	var parent_node = get_parent()
	var currentFloorOrder = parent_node.currentFloorOrder
	var swapMode = parent_node.swapMode
	
	#update local variable posisition, as well as #hide/show if floor is in use for the level (ex: FLoor D, E, and F aren't used in level 1)
	self.hide()
	var floorPos = null
	for i in range(0, len(currentFloorOrder), 1):
		if(currentFloorOrder[i][0] == floorLetter):
			self.show()
			floorPos = i
	
	if(floorPos != null):
	
		#update where the sprite appears on the order of floors
		self.scale = Vector2(4, 4)
		if(floorPos == 0):
			self.position = get_parent().get_node("sm_0").position
		elif(floorPos == 1):
			self.position = get_parent().get_node("sm_1").position
		elif(floorPos == 2):
			self.position = get_parent().get_node("sm_2").position
		elif(floorPos == 3):
			self.position = get_parent().get_node("sm_3").position
		elif(floorPos == 4):
			self.position = get_parent().get_node("sm_4").position
		elif(floorPos == 5):
			self.position = get_parent().get_node("sm_5").position
			
		#update sprite
		if((currentFloorOrder[floorPos][4] == true) and (swapMode == true)):
			get_parent().get_node("shadow").position = self.position
			get_parent().get_node("shadow").show()
			self.z_index = 2 #Set to 2 so its above the shadow
			if(floorPos == 0):
				self.position = get_parent().get_node("lm_0").position
			elif(floorPos == 1):
				self.position = get_parent().get_node("lm_1").position
			elif(floorPos == 2):
				self.position = get_parent().get_node("lm_2").position
			elif(floorPos == 3):
				self.position = get_parent().get_node("lm_3").position
			elif(floorPos == 4):
				self.position = get_parent().get_node("lm_4").position
			elif(floorPos == 5):
				self.position = get_parent().get_node("lm_5").position
				
		elif(currentFloorOrder[floorPos][3] == true): #locked floor
			self.z_index = 1
			get_node("floor").frame = 7
		else:
			self.z_index = 1
			if(floorLetter == "A"):
				get_node("floor").frame = 1
			elif(floorLetter == "B"):
				get_node("floor").frame = 2
			elif(floorLetter == "C"):
				get_node("floor").frame = 3
			elif(floorLetter == "D"):
				get_node("floor").frame = 4
			elif(floorLetter == "E"):
				get_node("floor").frame = 5
			elif(floorLetter == "F"):
				get_node("floor").frame = 6
			
		#update border of sprite
		if(currentFloorOrder[floorPos][4] == true): #if the floor is selected
			get_node("floorBorder").show()
			get_node("floorBorder").frame = 3
		elif((currentFloorOrder[floorPos][1] == true) and (currentFloorOrder[floorPos][2] == true)): #Both the player and the goal are on this floor
			get_node("floorBorder").show()
			get_node("floorBorder").frame = 2
		elif(currentFloorOrder[floorPos][1] == true): #only the player is on this floor
			get_node("floorBorder").show()
			get_node("floorBorder").frame = 0
		elif(currentFloorOrder[floorPos][2] == true): #only the goal is on this floor
			get_node("floorBorder").show()
			get_node("floorBorder").frame = 1
		else:
			get_node("floorBorder").hide()
