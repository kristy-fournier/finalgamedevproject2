extends CharacterBody2D
var lastPosition

var current_floor

var desired_position
var moving
var in_item = false
signal Detected_item
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	moving = false
	desired_position = self.position

func _physics_process(delta: float) -> void:
	var collision_info = move_and_collide(((desired_position-self.position))*1)
	if collision_info:
		desired_position = lastPosition
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	lastPosition = self.position
	if Input.is_action_just_pressed("move_left"):
		desired_position = self.position + Vector2(-16,0)
		moving = true
	if Input.is_action_just_pressed("move_right"):
		desired_position = self.position + Vector2(16,0)
		moving = true
	if Input.is_action_just_pressed("move_down"):
		desired_position = self.position + Vector2(0,16)
		moving = true
	if Input.is_action_just_pressed("move_up"):
		desired_position = self.position + Vector2(0,-16)
		moving = true
	check_offset()
	if (moving == true && desired_position == self.position):
		moving = false
		print("doneMoving")
		if(in_item):
			Detected_item.emit()	


func _on_area_2d_body_entered(body: Node2D) -> void:
	in_item = true
	print("hi")



func _on_area_2d_body_exited(body: Node2D) -> void:
	in_item = false
	print("bye")
	
	
#trying to fix the fact that the character position ends in .99999 after every move
func check_offset() -> void:
	if(snapped(self.position.x,0.0001) == desired_position.x && self.position != desired_position):
		print(self.position)
		print(desired_position)
		self.position = desired_position
	#if(snapped(self.position.y,0.0001) == desired_position.y && self.position != desired_position):
		#print(self.position)
		#print(desired_position)
		#self.position = desired_position
	#
	
