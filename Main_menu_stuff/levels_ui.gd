extends Node2D

var locked = true # Represents if the player has unlocked this level yet.
var number = 0 #Represents the number of this level (ex: level 2)
var background = "purple" #Represents the background color that will show up on the level select screen

func _ready():
	hide()
	#can't divide by 15 because we need 15 to be on page 1, 30 to be on page 2,... ect.
	if(number < 16):
		self.add_to_group("page1")
	elif(number < 31):
		self.add_to_group("page2")
	elif(number < 46):
		self.add_to_group("page3")
	elif(number < 61):
		self.add_to_group("page4")
	elif(number < 76):
		self.add_to_group("page5")
	elif(number < 91):
		self.add_to_group("page6")
	else:
		self.add_to_group("page7")

			
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
	
	
