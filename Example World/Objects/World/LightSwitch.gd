extends Node3D

@onready var shader_code = load("res://Example World/Objects/World/High.gdshader")
var shader_material
@export var Name = "Bed"
@onready var player = get_tree().get_root().get_node("World/LightBulb")
@onready var gato = preload("res://Dialog/Gato.dialogue") 
func PlayAction():
	

	DialogueManager.show_dialogue_balloon(gato,"start")
	print("JFKjlkdlkjLFLEDJFDJFLKDJFL")
	if has_node("AnimationPlayer"):
		print($AnimationPlayer.current_animation)
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

	
