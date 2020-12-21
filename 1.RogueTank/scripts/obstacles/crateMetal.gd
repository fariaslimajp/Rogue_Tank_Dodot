extends StaticBody2D

const PRE_FRAGMENTS = preload("res://scenes/fragments/crateMetal_fragments.tscn")

func _ready():
	$area_obstacle.connect("destroyed", self, "on_area_destroyed")
	$area_obstacle.connect("hitted", self, "on_area_hitted")

func on_area_destroyed():
	var fragments = PRE_FRAGMENTS.instance()
	fragments.global_position = global_position
	fragments.scale = scale
	fragments.rotation = rotation
	$"../".call_deferred("add_child", fragments)
	if has_node("sample"):
		$sample/explosion.play()
		get_node("area_obstacle").set_deferred("monitorable", false)
		get_node("area_obstacle").set_deferred("monitoring", false)
		$sprite.visible = false
		yield($sample/explosion, "finished")
	queue_free()

# warning-ignore:unused_argument
# warning-ignore:unused_argument
func on_area_hitted(damage, health, body):
	if self.has_node("anim"):
		if damage >= 15:
			$anim.play("big_hit")
		else:
			$anim.play("small_hit")
