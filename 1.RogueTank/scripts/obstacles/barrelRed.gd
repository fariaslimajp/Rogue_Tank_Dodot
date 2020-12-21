extends StaticBody2D

var PRE_OIL = preload("res://scenes/oilSpill_large.tscn")
var hit_sound = "small_hit01"

func _ready():
	$area_obstacle.connect("destroyed", self, "on_area_destroyed")
	$area_obstacle.connect("big_hit", self, "on_area_big_hit")
	$area_obstacle.connect("small_hit", self, "on_area_small_hit")
	randomize()

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
	if has_node("sample"):
		$sample/explosion.play()
	yield($anim,"animation_finished")
	queue_free()


func on_area_small_hit():
	if self.has_node("anim"):
		$anim.play("small_hit")
	if self.has_node("sample"):
		print (hit_sound)
		hit_sound = "small_hit0" +str(randi() % 5 + 1)
		get_node("sample/"+str(hit_sound)).play()
		
func on_area_big_hit():
	if self.has_node("anim"):
		$anim.play("big_hit")
	if self.has_node("sample"):
		$sample/big_hit.play()
