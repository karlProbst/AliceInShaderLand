extends StaticBody3D

@onready var shader_code = load("res://Example World/Objects/World/High.gdshader")
var shader_material

var growzao = false
@onready var rootNode = get_tree().get_root().get_node("World")
@onready var player = rootNode.get_node("Player_Character")
@onready var cat = rootNode.get_node("cat")

@export var Health = 2
@export var Name = "Shroom"
func Hit_Successful(Damage, _Direction: Vector3 = Vector3.ZERO, _Position: Vector3 = Vector3.ZERO):
	Health -= Damage
	if Health <= 0:
		queue_free()
func PlayAction():
	if has_node("AnimationPlayer"):
		$AnimationPlayer.play("ANIM")
	set_shader()
	if player.scale_var==player.scale_var_min:
		grow()
	else:
		growzao=true
	
func set_shader():
	var mesh_instance = $Mesh

func grow():
	player.scale_var=player.scale_var_default
	player.rootNode.time_of_day=6.5
	player.fade()
	player.global_position=Vector3(-0.1,3.5,13.72)
	get_node("cat").stop_radius=1.0
	rootNode.lanternLives=10
	rootNode.death=false

func _process(delta):
	if growzao:
		player.scale_var=player.scale_var*(1+(delta/16))
		if player.scale_var.x>2.45:
			cat.playerdied=true
