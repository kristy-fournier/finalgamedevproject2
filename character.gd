extends CharacterBody2D
var lastPosition

@onready var musicList = [load("res://Sound/move_1.mp3"),load("res://Sound/move_2.mp3"),load("res://Sound/move_3.mp3")]

var desired_position
var moving: bool
var in_item: bool
var in_menu = false
var levelSize = 1
signal Detected_item
signal Done_Moving
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	moving = false
	desired_position = self.position

func _physics_process(delta: float) -> void:
	var collision_info = move_and_collide(((desired_position-self.position))*levelSize*delta*40)
	if collision_info:
		desired_position = lastPosition
	if desired_position.round() == self.position.round():
		self.position = self.position.round()
		if(moving == true):
			Done_Moving.emit()
		moving = false
		if(in_item):
			_overlap_handler()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	lastPosition = self.position
	if Input.is_action_just_pressed("menu_action"):
		if(in_menu):
			in_menu = false
		else:
			in_menu = true
	if !(in_menu):
		if Input.is_action_just_pressed("move_left") and moving==false:
			desired_position = self.position + Vector2(-16,0)
			moving = true
			$MoveSound.play()
		if Input.is_action_just_pressed("move_right") and moving==false:
			moving = true
			desired_position = self.position + Vector2(16,0)
			$MoveSound.play()
		if Input.is_action_just_pressed("move_down") and moving==false:
			moving = true
			desired_position = self.position + Vector2(0,16)
			$MoveSound.play()
		if Input.is_action_just_pressed("move_up") and moving==false:
			moving = true
			desired_position = self.position + Vector2(0,-16)
			$MoveSound.play()

func setPosition(newPos:Vector2i):
	self.position = Vector2(newPos)
	self.lastPosition = Vector2(newPos)
	self.desired_position = Vector2(newPos)

func _on_area_2d_body_entered(body: Node2D) -> void:
	in_item = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	in_item = false

func _overlap_handler() -> void:
	Detected_item.emit()
	in_item = false

func _on_draw() -> void:
	$CollisionShape2D.disabled = false
	$Area2D/CollisionShape2D.disabled = false
	
func _on_hidden() -> void:
	$CollisionShape2D.disabled = true
	$Area2D/CollisionShape2D.disabled = true
