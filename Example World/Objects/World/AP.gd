extends Node3D

func _ready():
	# Iterate over all children of this node
	for child in get_children():
		if child is MeshInstance3D:
			# Check if the material is a StandardMaterial3D or if material needs to be created
			var material = child.material_override
			if material == null or not material is StandardMaterial3D:
				# Create a new StandardMaterial3D if none is attached
				material = StandardMaterial3D.new()
				child.material_override = material

			# Generate a random color
			var d = 3
			var random_color = Color(randf() / d, randf() / d, randf() / d)
			material.albedo_color = random_color
			

