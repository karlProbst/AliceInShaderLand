extends Node3D

func _ready():
	# Iterate over all children of this node
	for child in get_children():
		if child is MeshInstance3D:
			# Ensure there are enough material override slots
			if child.get_surface_override_material_count() > 1:
				# Handle the second slot for emission
				var emission_material = child.get_surface_override_material(1)
				if emission_material == null:
					emission_material = StandardMaterial3D.new()
					child.set_surface_override_material(1, emission_material)
				var random_color = Color(randf()*5, randf()*5, randf()*5)
				
				
				var r = randf_range(0.0,100.0)
				if(r<80):
					r=0.0
				else:
					emission_material.emission_enabled = true
					emission_material.emission = random_color
					emission_material.emission_energy = r/20
			else:
				# Print an error message if there are not enough materials
				print("Not enough materials in material_override to assign to slot 1.")
