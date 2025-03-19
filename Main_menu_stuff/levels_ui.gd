extends Node2D

var locked = true # Represents if the player has unlocked this level yet.
var number = 0 #Represents the number of this level (ex: level 2)
var background = "purple" #Represents the background color that will show up on the level select screen

func _ready():
	show()
	#Set color of background
	if(self.background == "purple"):
		get_node("background").frame = 0
	elif(self.background == "blue"):
		get_node("background").frame = 1
	elif(self.background == "black"):
		get_node("background").frame = 2
	
	#Check if locked:
	if(self.locked == true):
		get_node("layer1").frame = 0
	else:
		#Otherwise set the number
		if(self.number <= 0):
			get_node("layer1").hide()
			get_node("layer2").hide()
			print("Error from levels_UI.gd (Main_menu), tried to create a level with number less than or equal to zero.")
		elif(self.number < 10): #If less than 10, we use the centered sprites
			get_node("layer1").frame = self.number
			get_node("layer2").hide()
		else:
			var digits = []
			for char in str(self.number):
				digits.append(int(char))
			get_node("layer1").frame = digits[0] + 9
			get_node("layer2").frame = digits[1]
	
	
