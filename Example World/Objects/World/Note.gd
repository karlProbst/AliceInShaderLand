extends StaticBody3D


var coin_scene = preload("res://Assets 3d/Coin.tscn")
var shader_material
@export var Name = "Note"
@onready var player = get_tree().get_root().get_node("World/Player_Character")
var open = false
func PlayAction():
	
	if has_node("AnimationPlayer"):
		$AnimationPlayer.play("ANIM")
	player.interface="note"
	player.StartMenu()

	
func set_shader():
	var mesh_instance = $Mesh







