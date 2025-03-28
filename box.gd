extends RigidBody2D

var lastPosition


var desired_position
var moving: bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	moving = false
	desired_position = self.position

func _physics_process(delta: float) -> void:
	var collision_info = move_and_collide(((desired_position-self.position))*1)
	if collision_info:
		desired_position = lastPosition
	if desired_position.round() == self.position.round():
		self.position = self.position.round()
		if(moving == true):
			moving = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




func _on_body_entered(body: Node) -> void:
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
