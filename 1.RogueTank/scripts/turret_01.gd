extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_sensor_body_entered(body):
	print("entrou")
	pass # Replace with function body.


func _on_sensor_body_exited(body):
	print("saiu")
	pass # Replace with function body.
