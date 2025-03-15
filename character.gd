extends CharacterBody2D
var lastPosition

var current_floor
var desired_position
var moving: bool
var in_item: bool
signal Detected_item
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	moving = false
	desired_position = self.position

func _physics_process(delta: float) -> void:
	var collision_info = move_and_collide(((desired_position-self.position))*1)
	if collision_info:
		desired_position = lastPosition
	print(self.position)
	print(desired_position)
	if desired_position.round() == self.position.round():
		self.position = self.position.round()
		moving = false
		if(in_item):
			_overlap_handler()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	lastPosition = self.position
	if Input.is_action_just_pressed("move_left") and moving==false:
		desired_position = self.position + Vector2(-16,0)
		moving = true
	if Input.is_action_just_pressed("move_right") and moving==false:
		moving = true
		desired_position = self.position + Vector2(16,0)
	if Input.is_action_just_pressed("move_down") and moving==false:
		moving = true
		desired_position = self.position + Vector2(0,16)
	if Input.is_action_just_pressed("move_up") and moving==false:
		moving = true
		desired_position = self.position + Vector2(0,-16)


func _on_area_2d_body_entered(body: Node2D) -> void:
	in_item = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	in_item = false

func _overlap_handler() -> void:
	Detected_item.emit()
