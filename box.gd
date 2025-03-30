extends StaticBody2D

@onready var lastPosition = self.position


@onready var desired_position = self.position
var moving: bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	moving = false

func _physics_process(delta: float) -> void:
	var collision_info = move_and_collide(((desired_position-self.position))*1)
	if collision_info:
		desired_position = lastPosition
	if desired_position.round() == self.position.round():
		self.position = self.position.round()
		moving = false
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(lastPosition)
	lastPosition = self.position
	pass




func _on_body_entered(body: Node) -> void:
	print("hi")
	if ((self.position - body.position).normalized() == Vector2(1,0) and moving == false ):
		desired_position = self.position + Vector2(16,0)
		moving = true
	if (self.position - body.position).normalized() == Vector2(-1,0) and moving == false:
		moving = true
		desired_position = self.position + Vector2(-16,0)
	if (self.position - body.position).normalized() == Vector2(0,-1) and moving == false:
		moving = true
		desired_position = self.position + Vector2(0,-16)
	if (self.position - body.position).normalized() == Vector2(0,1) and moving == false:
		moving = true
		desired_position = self.position + Vector2(0,16)
