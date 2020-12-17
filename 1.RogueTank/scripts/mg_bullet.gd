extends Area2D

var vel = 300
var dir = Vector2()
var max_distance = 150
onready var initPos = global_position
var damage = 1

func _physics_process(delta):
	translate (dir * vel * delta)
	if global_position.distance_to(initPos) > max_distance:
		autodestroy()

func _on_mg_bullet_area_entered(area):
	if area.has_method("hit"):
		area.hit(damage,self)
		autodestroy()

func autodestroy():
	queue_free()
	
# warning-ignore:unused_argument
func _on_mg_bullet_body_entered(body):
	autodestroy()
