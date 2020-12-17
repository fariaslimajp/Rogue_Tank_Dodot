extends Node2D

var bodies = 0

func _ready():
	for c in get_children():
		c.connect("tree_exited", self, "on_fragment_tree_exited")
		if c is RigidBody2D:
			bodies +=1


func on_fragment_tree_exited():
	bodies -=1
	print (bodies)
	if bodies <= 0:
		print("deletando")
		queue_free()
