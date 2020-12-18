tool
extends KinematicBody2D

var BULLET_TANK_GROUP = "bullet-"+ str(self)
const ROT_VEL = PI / 1.7  #PI = 180 graus
const MAX_SPEED = 120

var acell = 0
var joystick_mode = false
var deadzone = 0.7
var loaded = true
var move
var pre_bullet = preload("res://scenes/bullets/bullet.tscn")
var pre_mg_bullet = preload("res://scenes/bullets/mg_bullet.tscn")
var pre_track = preload("res://scenes/track.tscn")

var travell = 0
var vel_mod = 1


export(int, "Blue_barrel1", "Blue_barrel2", "Blue_barrel3", "Dark_barrel1", "Dark_barrel2", "Dark_barrel3", "Green_barrel1", "Green_barrel2", "Green_barrel3", "Red_barrel1", "Red_barrel2", "Red_barrel3", "Sand_barrel1", "Sand_barrel2", "Sand_barrel3") var barrel = 0 setget set_barrel
export(int, "Blue", "Dark", "Green", "Red", "Sand", "DarkLarge", "BigRed", "Huge") var bodie = 0 setget set_bodie

#LISTA DE SPRITES
var barrels = [
	"res://sprites/tankBlue_barrel1_outline.png",
	"res://sprites/tankBlue_barrel2_outline.png",
	"res://sprites/tankBlue_barrel3_outline.png",
	"res://sprites/tankDark_barrel1_outline.png",
	"res://sprites/tankDark_barrel2_outline.png",
	"res://sprites/tankDark_barrel3_outline.png",
	"res://sprites/tankGreen_barrel1_outline.png",
	"res://sprites/tankGreen_barrel2_outline.png",
	"res://sprites/tankGreen_barrel3_outline.png",
	"res://sprites/tankRed_barrel1_outline.png",
	"res://sprites/tankRed_barrel2_outline.png",
	"res://sprites/tankRed_barrel3_outline.png",
	"res://sprites/tankSand_barrel1_outline.png",
	"res://sprites/tankSand_barrel2_outline.png",
	"res://sprites/tankSand_barrel3_outline.png"
]

var bodies = [
	"res://sprites/tankBody_blue.png",                 #0
	"res://sprites/tankBody_dark.png",                 #1
	"res://sprites/tankBody_green.png",                #2
	"res://sprites/tankBody_red.png",                  #3
	"res://sprites/tankBody_sand.png",                 #4
	"res://sprites/tankBody_darkLarge.png",            #5
	"res://sprites/tankBody_bigRed.png",               #6
	"res://sprites/tankBody_huge.png"                  #7
]

var specialBarrels = [
	"res://sprites/specialBarrel1_outline.png",       #0
	"res://sprites/specialBarrel2_outline.png",       #1
	"res://sprites/specialBarrel3_outline.png",       #2
	"res://sprites/specialBarrel4_outline.png",       #3
	"res://sprites/specialBarrel5_outline.png",       #4
	"res://sprites/specialBarrel6_outline.png",       #5
	"res://sprites/specialBarrel7_outline.png"        #6
]

func _ready():
	pass

func _input(event):
#	print(event)
	if event is InputEventMouseMotion:
		joystick_mode = false
	if event is InputEventJoypadMotion:
		joystick_mode = true

func _draw():
	$sprite.texture = load(bodies[bodie])
	$barrel/sprite.texture = load(barrels[barrel])
# warning-ignore:unused_argument
func _physics_process(delta): #usa o process para objetos que trabalham com física
	if Engine.editor_hint: #se tiver no modo editor
		return
	phisic_move()
	shoots()
	print_track()

func phisic_move():
	var rot = 0
	var dir = 0
# VERIFICAÇÃO SE O JOGADOR USA OU NÃO O JOYSTICK
	if joystick_mode:
		# VERIFICAÇÃO DE DEADZONE
		var rot_hor_axis = Input.get_joy_axis(0, JOY_AXIS_2)
		var rot_ver_axis = Input.get_joy_axis(0, JOY_AXIS_3)
		var vector = Vector2(rot_hor_axis,rot_ver_axis)
		if vector.length() > deadzone:
			$barrel.global_rotation = vector.normalized().angle()
	else:
		$barrel.look_at(get_global_mouse_position())

	if Input.is_action_pressed("ui_left"):
		rot -= 1
	if Input.is_action_pressed("ui_right"):
		rot += 1
	if Input.is_action_pressed("ui_up"):
		dir +=1
	if Input.is_action_pressed("ui_down"):
		dir -=1

# ROTAÇÃO, ACELERACAO E DESACELERAÇÃO UTILIZANDO O ANALOGICO DO JOYSTICK.
	if rot == 0:
		rot = Input.get_joy_axis(0, JOY_AXIS_0)
	if dir == 0:
		dir = -Input.get_joy_axis(0, JOY_AXIS_1)

	if dir !=0:
		acell = lerp(acell, MAX_SPEED * dir, 0.02) #comando responsavel para ir do valor "acell" para o valor "MAX_SPEED"
	else:
		acell = lerp(acell, MAX_SPEED * dir, 0.05) #comando responsavel para ir do valor "acell" para o valor "MAX_SPEED"
	
	rotate(ROT_VEL * get_physics_process_delta_time() * rot)
	spill_oil()
	move = move_and_slide(Vector2(cos(rotation), sin(rotation)) * acell * vel_mod) #recebe dados de posição e movimento

func old_move():
	var dir_x = 0
	var dir_y = 0
	
	if Input.is_action_pressed("ui_left"):
		dir_x -= 1
	if Input.is_action_pressed("ui_right"):
		dir_x += 1
	if Input.is_action_pressed("ui_up"):
		dir_y -= 1
	if Input.is_action_pressed("ui_down"):
		dir_y += 1
	look_at(get_global_mouse_position())
# warning-ignore:return_value_discarded
	move_and_slide( Vector2(dir_x,dir_y) *  MAX_SPEED )

func print_track():
	travell += move.length() * get_physics_process_delta_time()
	if travell >= $sprite.texture.get_size().y:
		travell = 0
		var track = pre_track.instance()
		track.global_position = global_position - Vector2(cos(rotation), sin(rotation)).normalized() * 4
		track.rotation = rotation
		track.z_index = z_index - 1
		get_parent().add_child(track)

func shoots():
	if Input.is_action_just_pressed("ui_shoot"):
		cannon_shoot()
	if Input.is_action_just_pressed("ui_mg_shoot"):
		$mg/mg_timer.start()
		mg_shoot()
	if Input.is_action_just_released("ui_mg_shoot"):
		$mg/mg_timer.stop()


func spill_oil():
	vel_mod = 1
	if get_tree().get_nodes_in_group(str(self)+"-oil").size() > 0:
		vel_mod = 0.3

func cannon_shoot():
#	var limiter = 3	
#		if get_tree().get_nodes_in_group(BULLET_TANK_GROUP).size() < limiter:
	if loaded == true:
		var bullet = pre_bullet.instance()
		bullet.global_position = $barrel/muzzle.global_position
		bullet.dir = Vector2(cos($barrel.global_rotation), sin($barrel.global_rotation)).normalized()
		bullet.add_to_group(BULLET_TANK_GROUP)
		bullet.max_distance = $barrel/sight.position.x - $barrel/muzzle.position.x - 9
		$"../".add_child(bullet)
		$barrel/anim.play("fire")
		$barrel/anim.play("barrel_shoot")
		loaded = false
		$barrel/sight.update()
		$barrel/time_reload.start()

func mg_shoot():
	var mg_bullet = pre_mg_bullet.instance()
	mg_bullet.global_position = $mg/muzzle.global_position
	mg_bullet.global_rotation = $mg/muzzle.global_rotation
	mg_bullet.dir = Vector2(cos($mg.global_rotation), sin($mg.global_rotation)).normalized()
	get_parent().add_child(mg_bullet)

func set_bodie(val):
	bodie = val
	if Engine.editor_hint: #se tiver no modo editor
		update()

func set_barrel(val):
	barrel = val
	if Engine.editor_hint: #se tiver no modo editor
		update()

func _on_time_reload_timeout():
	loaded = true
	$barrel/sight.update()

func _on_mg_timer_timeout():
	mg_shoot()
