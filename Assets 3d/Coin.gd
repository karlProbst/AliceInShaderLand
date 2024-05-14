extends RigidBody3D





var needsWater=true

@onready var shader_code = load("res://Example World/Objects/World/High.gdshader")

var shader_material
@export var Name = "Bed"
@onready var player = get_tree().get_root().get_node("World/Player_Character")

func PlayAction():
	print(global_position)
	if has_node("AnimationPlayer"):
		$AnimationPlayer.play("ANIM")
	queue_free()

func set_shader():
	var mesh_instance = $Mesh


func _on_body_entered(body):
	if body.is_in_group("Ray"):
		body.queue_free()
		queue_free()



