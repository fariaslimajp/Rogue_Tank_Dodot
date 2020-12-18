extends RigidBody2D


func _ready():
	randomize()
	apply_torque_impulse(randf())
	gravity_scale = 0
	linear_damp = 2
	angular_velocity = randf() * 20
	var dir = randf() * PI * 2
	apply_impulse(Vector2(),Vector2(cos(dir), sin(dir)) * 200) 
	$poly.scale = get_parent().scale
	$collision_poly.scale = get_parent().scale
	connect("sleeping_state_changed", self,"on_self_sleeping_state_changed")
	
func on_self_sleeping_state_changed():
	var timer = get_tree().create_timer(randf() * 10 + 2)
	yield(timer, "timeout")
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_method(self, "fade", Color(1,1,1,1), Color(1,1,1,0) ,2,Tween.TRANS_LINEAR,Tween.EASE_OUT,0)
	tween.start()
	yield(tween, "tween_completed")
	queue_free()

func fade(val):
	modulate = val
