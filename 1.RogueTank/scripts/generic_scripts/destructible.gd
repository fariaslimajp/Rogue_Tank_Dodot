extends Area2D

export var health = int()

signal big_hit
signal destroyed
signal hitted(damage, health, node)
signal small_hit

func _ready():
	if health == 0:
		health = 1
		print("O objeto ", $"../".name, " teve a vida atualizada para o valor minimo vivo (", health, ")")

func hit (damage, node):
	health -= damage
	emit_signal("hitted", damage, health, node)
	
	if health <= 0:
		emit_signal("destroyed")
	if damage >= 15:
		emit_signal("big_hit")
	else:
		emit_signal("small_hit")
