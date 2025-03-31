extends Node2D
var Lvlcenter = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()

func turn_on():
	show()
	get_node("AnimatedSprite2D").pause()
	get_node("AnimatedSprite2D").frame = 0
	self.global_position = (get_node("endPos").global_position + Vector2(0, 800))
	self.scale = Vector2(5, 5)
	var tween = create_tween()
	get_node("endPos").global_position = Lvlcenter
	tween.tween_property(self, "global_position", get_node("endPos").global_position, 0.2).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "scale", Vector2(6.25, 6.25), 0.2).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	get_node("tweenDuration").start()
func _on_tween_duration_timeout():
	get_node("AnimatedSprite2D").play()
	
func turn_off():
	get_node("AnimatedSprite2D").frame = 0
	get_node("AnimatedSprite2D").pause()
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(5, 5), 0.2).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "global_position", get_node("endPos").global_position + Vector2(0, 800), 0.2).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	
func _process(delta: float):
	get_node("endPos").global_position = Lvlcenter
	
	
