extends Node3D

@onready var shader_code = load("res://Example World/Objects/World/High.gdshader")
@onready var player = get_tree().get_root().get_node("World/Player_Character")
var Name="RegadorPOrra"
func PlayAction():
	set_shader()
	player.hasRegador=true
	self.visible=false
	self.remove_from_group("Interactible")
	
func set_shader():
	var mesh_instance = $Mesh

	
