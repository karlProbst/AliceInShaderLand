extends Node3D

@onready var shader_code = load("res://Example World/Objects/World/High.gdshader")
var shader_material
@export var Name = "Bed"
@onready var player = get_tree().get_root().get_node("World/Player_Character")
@onready var ap = get_tree().get_root().get_node("World/AP")
@onready var rootNode = get_tree().get_root().get_node("World")
@onready var plants = get_tree().get_root().get_node("World/AP/Plants")
func PlayAction():
	if player.catHipnose<=0:
		print("JFKjlkdlkjLFLEDJFDJFLKDJFL")
		if has_node("AnimationPlayer"):
			$AnimationPlayer.play("ANIM")
		set_shader()
		player.fade()
		ap.Recolor()
		rootNode.time_of_day=22.0
		player.stuck=7.0
		plants.resetPlants()
		player.setFov(35)
		player.catHipnose=7.0
		
func set_shader():
	var mesh_instance = $Mesh

	
