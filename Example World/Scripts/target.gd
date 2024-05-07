extends StaticBody3D

@onready var shader_code = load("res://Example World/Objects/World/High.gdshader")
var shader_material



@export var Health = 2
@export var Name = "ALVO"
func Hit_Successful(Damage, _Direction: Vector3 = Vector3.ZERO, _Position: Vector3 = Vector3.ZERO):
	Health -= Damage
	if Health <= 0:
		queue_free()
func PlayAction():
	if has_node("AnimationPlayer"):
		$AnimationPlayer.play("ANIM")
	set_shader()
	
func set_shader():
	var mesh_instance = $Mesh

	
