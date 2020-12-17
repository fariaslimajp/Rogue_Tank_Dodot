extends Area2D

onready var init_pos = global_position

var dir = Vector2(0,-1) setget set_dir #toda vez que essa variavel for modificada, ele chama essa funcao
var live = true
var speed = 350
var max_distance = 400
var damage = 15

func _ready():
	pass # Replace with function body.

func _process(delta):
	if live:
		if global_position.distance_to(init_pos) > max_distance:
			autodestroy()
		translate(dir * speed * delta)

func _on_notifier_screen_exited():
	queue_free()

# warning-ignore:unused_argument
func _on_bullet_body_entered(body):
		autodestroy()

func autodestroy():
		$smoke.emitting = false
		$sprite.visible = false
		live = false
		$anim_self_destruction.play("explode")
		set_deferred("monitorable", false)
		set_deferred("monitoring", false)
		yield($anim_self_destruction, "animation_finished")
		queue_free()

func set_dir(val):
	dir = val
	rotation = dir.angle()


func _on_bullet_area_entered(area):
	if area.has_method("hit"):
		area.hit(damage, self)
		autodestroy()
