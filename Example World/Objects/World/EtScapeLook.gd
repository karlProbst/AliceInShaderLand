extends Node3D

var et_scene = preload("res://Scenes/et.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func spawn_et(n):
	$AnimationPlayer.play()
	for i in range(n):
		var locationVec=self.global_transform.origin+Vector3(randf_range(-2,2),randf_range(-2,2),randf_range(-2,2))
		var et = et_scene.instantiate()
		add_child(et)  # Add coin to the scene tree
		et.set_global_position(locationVec) # Randomize the spawn location
		var impulse = Vector3(randf_range(-1, 1), randf_range(0, 0.5), randf_range(-1, 1))
		# Apply an initial upward force
		et.apply_impulse(impulse, impulse)  # Adjust the range as needed
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
