extends Node2D
var stepsTaken = 0 # used for the first level text
var keyboardMode:bool
var itemDetected
var currentLevelNum:int
var currentTutorialNum:int
# input images
var direcIn1 # WASD or D-PAD
var direcIn2 # Arrow or L-Stick
var upIn # W or D-pad up
var downIn # s or dpad down
var selectIn #space or "A"
var menuIn # Tab or Select (Or "B"?)
#follows a format of tutorialText[levelNum][tutorialNum]

var tutorialText

func setTutorialText():
	# for some reason variables in 
	tutorialText = {
		1:{
			1:["Use ",direcIn1," or ",direcIn2," to move"],
			2:["The green door is the exit"]
		},
		2:{
			1:["Use ",menuIn," to use your SpiritConnect"],
			2:["Use ",upIn," and ",downIn," to preview other floors"],
			3:["Grab floors with ",selectIn,"\nTry switching floors A & B"],
			4:["Now that there’s a hole above the ladder,\nyou can use it to move between floors."]
		},
		3:{
			1:["In SpiritConnect, white shows your \nlocation and green shows the exit"]
		},
		4:{
			1:["Trapdoors are like holes, \nbut only when ladders are below"]
		}
	}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	changeTo(false)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# this checks the pass condition for each tutorial. i wanted to keep this node as indepenant
	# from main as possible (there's so much stuff in main already
	if currentLevelNum == 1:
		if currentTutorialNum == 1:
			if Input.is_action_just_pressed("move_down") or Input.is_action_just_pressed("move_up") or Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right"):
				stepsTaken+=1
			if stepsTaken > 5:
				loadLevelTutorial(1,2)
	elif currentLevelNum == 2:
		if currentTutorialNum == 1:
			if Input.is_action_just_pressed("menu_action"):
				loadLevelTutorial(2,2)
		if currentTutorialNum == 2:
			if Input.is_action_just_pressed("move_down") or Input.is_action_just_pressed("move_up"):
				loadLevelTutorial(2,3)
		if currentTutorialNum == 3:
			if Input.is_action_just_pressed("menu_action"):
				loadLevelTutorial(2,4)
	# Not working rn so its just gonna stay on the whole level
	#elif currentLevelNum == 4:
		#if itemDetected:
			#$RichTextLabel.clear()
			#$RichTextLabel.visible = false
			
			
			

func _input(event):
	if self.visible == true:
		if(event is InputEventKey and not(keyboardMode)):
			changeTo(true)
			loadLevelTutorial(currentLevelNum,currentTutorialNum)
		elif(event is InputEventJoypadButton or event is InputEventJoypadMotion) and keyboardMode:
			changeTo(false)
			loadLevelTutorial(currentLevelNum,currentTutorialNum)
	

func loadLevelTutorial(levelNum:int,tutorialNum:int):
	stepsTaken = 0
	itemDetected = false
	currentLevelNum=levelNum
	currentTutorialNum=tutorialNum
	$RichTextLabel.clear()
	if currentLevelNum in tutorialText:
		$RichTextLabel.visible = true
		var stylebox = StyleBoxFlat.new()
		stylebox.bg_color = Color(0, 0, 0, 0.5)
		$RichTextLabel.add_theme_stylebox_override("normal", stylebox)
		var currentTutorial = tutorialText[levelNum][tutorialNum]
		$RichTextLabel.append_text("[center]")
		for i in currentTutorial:
			if not(i.ends_with(".png")):
				$RichTextLabel.append_text(i)
			elif i.contains("arrows") or i.contains("wasd"):
				$RichTextLabel.append_text("[img=50]res://Art/Controller Glyphs/"+i+"[/img]")
			else:
				$RichTextLabel.append_text("[img=25]res://Art/Controller Glyphs/"+i+"[/img]")
	else:
		$RichTextLabel.visible = false
	

func changeTo(keyboard:bool):
	keyboardMode = keyboard
	if keyboard == true:
		upIn = "Keyboard Light/W_Key_Light.png"
		downIn = "Keyboard Light/S_Key_Light.png"
		direcIn1 = "Keyboard Light/wasd.png"
		direcIn2 = "Keyboard Light/arrows.png"
		selectIn = "Keyboard Light/Space_Key_Light.png"
		menuIn = "Keyboard Light/Tab_Key_Light.png"
	else:
		upIn = "Xbox 360/360_Dpad_Up.png"
		downIn = "Xbox 360/360_Dpad_Down.png"
		direcIn1 = "Xbox 360/360_Dpad.png"
		direcIn2 = "Xbox 360/360_Left_Stick.png"
		selectIn = "Xbox 360/360_A.png"
		menuIn = "Xbox 360/360_B.png"
	setTutorialText()
		


func _on_character_detected_item() -> void:
	itemDetected = true
