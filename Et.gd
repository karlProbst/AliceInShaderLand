extends RigidBody3D

#@onready var node=get_tree().get_root().get_node("World/EtScapeLook")
@onready var node=get_tree().get_root().get_node("World/Lanterna")
# Called when the node enters the scene tree for the first time.
var force_magnitude: float = 0.015
# Define damping factors to reduce unwanted lateral movement and rotation.
var linear_damping: float = 0.8
var angular_damping: float = 1
func _ready():
# Define the magnitude of the forward force.

	linear_damp = linear_damping
	angular_damp = angular_damping
func _physics_process(delta):

	if node:
		look_at(node.global_transform.origin,Vector3(0,1,0),true)

		var forward_direction: Vector3 = -global_transform.basis.z
	
		var force: Vector3 = forward_direction * -force_magnitude
		apply_central_force(force)
