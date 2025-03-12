extends Node2D
var lastPosition

var current_floor
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	lastPosition = self.position
	if Input.is_action_just_pressed("move_right"):
		self.position = self.position + Vector2(-16,0)
	if Input.is_action_just_pressed("move_left"):
		self.position = self.position + Vector2(16,0)
	if Input.is_action_just_pressed("move_down"):
		self.position = self.position + Vector2(0,16)
	if Input.is_action_just_pressed("move_up"):
		self.position = self.position + Vector2(0,-16)
