extends Area2D

export var health = int()

signal hitted(damage, health, node)
signal destroyed()

func _ready():
	if health == 0:
		health = 1
		print("O objeto ", $"../".name, " teve a vida atualizada para o valor minimo vivo (", health, ")")

func hit (damage, node):
	health -= damage
	emit_signal("hitted", damage, health, node)
	if health <= 0:
		$"../".queue_free()
		emit_signal("destroyed")
