extends StaticBody2D

var PRE_OIL = preload("res://scenes/oilSpill_large.tscn")

func _ready():
# warning-ignore:return_value_discarded
	$area_obstacle.connect("destroyed", self, "on_area_destroyed")
# warning-ignore:return_value_discarded
	$area_obstacle.connect("hitted", self, "on_area_hitted")
	$area_obstacle.connect("big_hit", self, "on_area_big_hit")
	$area_obstacle.connect("small_hit", self, "on_area_small_hit")


func on_area_destroyed():
	var oil_count = 5
	for _o in range(oil_count):
		var oil = PRE_OIL.instance()
		var angle = randf() * PI * 2
		oil.global_position = global_position + Vector2(cos(angle), sin(angle)).normalized() * $sprite.texture.get_size() * (randf()*2)
		oil.scale = scale /2
		get_parent().call_deferred("add_child", oil)
		oil.get_node("anim").play("scale")
		oil.z_index = z_index - 1

	$anim.play("explode")
	get_node("area_obstacle").set_deferred("monitorable", false)
	get_node("area_obstacle").set_deferred("monitoring", false)
	yield($anim,"animation_finished")
	queue_free()

# warning-ignore:unused_argument
# warning-ignore:unused_argument
func on_area_hitted(damage, health, body):
	if self.has_node("anim"):
		pass

func on_area_small_hit():
	$anim.play("small_hit")
	if self.has_node("sample"):
		$sample/small_hit.play()
		
func on_area_big_hit():
	$anim.play("big_hit")
	if self.has_node("sample"):
		$sample/big_hit.play()
