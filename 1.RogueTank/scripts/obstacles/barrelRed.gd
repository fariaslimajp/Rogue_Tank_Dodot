extends StaticBody2D
var PRE_OIL = preload("res://scenes/oilSpill_large.tscn")

func _ready():
# warning-ignore:return_value_discarded
	$area_obstacle.connect("destroyed", self, "on_area_destroyed")
# warning-ignore:return_value_discarded
	$area_obstacle.connect("hitted", self, "on_area_hitted")

func on_area_destroyed():
	var oil_count = 5
	for o in range(oil_count):
		var oil = PRE_OIL.instance()
		var angle = randf() * PI * 2
		oil.global_position = global_position + Vector2(cos(angle), sin(angle)).normalized() * $sprite.texture.get_size() * (randf()*2)
		oil.scale = scale
		get_parent().add_child(oil)
		oil.get_node("anim").play("scale")
		
	$anim.play("explode")
	yield($anim,"animation_finished")
	queue_free()

# warning-ignore:unused_argument
# warning-ignore:unused_argument
func on_area_hitted(damage, health, body):
	if self.has_node("anim"):
		if damage >= 15:
			$anim.play("big_hit")
		else:
			$anim.play("small_hit")
