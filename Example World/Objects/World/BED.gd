extends Node3D

@onready var shader_code = load("res://Example World/Objects/World/High.gdshader")
var shader_material
@export var Name = "Bed"
@onready var player = get_tree().get_root().get_node("World/Player_Character")
@onready var ap = get_tree().get_root().get_node("World/AP")

func PlayAction():
	print("JFKjlkdlkjLFLEDJFDJFLKDJFL")
	if has_node("AnimationPlayer"):
		$AnimationPlayer.play("ANIM")
	set_shader()
	
	player.fade()
	ap.Recolor()
func set_shader():
	var mesh_instance = $Mesh

	
