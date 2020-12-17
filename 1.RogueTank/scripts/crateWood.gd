extends StaticBody2D


func _ready():
	$area_obstacle.connect("hitted", self, "on_area_hitted")
	$area_obstacle.connect("destroyed", self, "on_area_destroyed")

func on_area_hitted(damage, health, body):
	pass

func on_area_destroyed():
	queue_free()
