extends MeshInstance3D

@onready var shader_code = load("res://Example World/Objects/World/High.gdshader")
var shader_material
@export var Name = "ALVO"
@onready var player = get_tree().get_root().get_node("Player_Character")

func PlayAction():
	if has_node("AnimationPlayer"):
		$AnimationPlayer.play("ANIM")
	set_shader()
	player.fade()
	
func set_shader():
	var mesh_instance = $Mesh

	
