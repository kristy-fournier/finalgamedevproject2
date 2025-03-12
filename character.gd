extends CharacterBody2D
var lastPosition

var current_floor

var desired_position
var moving
signal Change_floors
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
	if Input.is_action_just_pressed("move_right"):
		desired_position = self.position + Vector2(16,0)
	if Input.is_action_just_pressed("move_down"):
		desired_position = self.position + Vector2(0,16)
	if Input.is_action_just_pressed("move_up"):
		desired_position = self.position + Vector2(0,-16)


func _on_area_2d_body_entered(body: Node2D) -> void:
	Change_floors.emit()
