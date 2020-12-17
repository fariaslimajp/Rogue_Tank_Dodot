tool
extends Node2D

func _ready():
	rotate(PI/4)

func _draw():
	var color
	if $"../../".loaded:
		color = Color(0,0.8,0.3)

	else:
		color = Color(0.9,0,0.3)
	draw_arc(Vector2(),3,PI,-PI,20,color,2)
	draw_line(Vector2(3,0),Vector2(8,0),color,2)
	draw_line(Vector2(-3,0),Vector2(-8,0),color,2)
	draw_line(Vector2(0,3),Vector2(0,8),color,2)
	draw_line(Vector2(0,-3),Vector2(0,-8),color,2)
#	print("pintei")
