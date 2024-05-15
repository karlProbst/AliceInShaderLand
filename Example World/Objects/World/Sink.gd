extends Node3D

@onready var shader_code = load("res://Example World/Objects/World/High.gdshader")
var shader_material
@export var Name = "Sink"
@onready var player = get_tree().get_root().get_node("World/Player_Character")

func PlayAction():
	if player.hasRegador:
		player.refillWater()
	if has_node("AnimationPlayer"):
		if $AnimationPlayer.current_animation=="on":
			$AnimationPlayer.play("off")
			print("on>off")
			return
		else:
			$AnimationPlayer.play("on")
			print("off>on")
			return
	set_shader()
	
	
func set_shader():
	var mesh_instance = $Mesh

	
