extends Node2D


func _ready():
	$timer_queue.start(int(rand_range(7, 15)))
	
func _on_timer_queue_timeout():
	$anim.play("hide")
	yield($anim, "animation_finished")
	queue_free()	
