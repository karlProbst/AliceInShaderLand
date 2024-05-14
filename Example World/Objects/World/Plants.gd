extends Node3D

func _ready():
	resetPlants()
func resetPlants():
	# Iterate over all children of this node
	for child1 in get_children():
		if child1.has_method("watering"):
			child1.needsWater=true
		for child in child1.get_children(0):
			if child is MeshInstance3D:
				# Check if the material is a StandardMaterial3D or if material needs to be created
				var material = child.material_override
				if material == null or not material is StandardMaterial3D:
					# Create a new StandardMaterial3D if none is attached
					material = StandardMaterial3D.new()
					child.material_override = material
				# Generate a random color
				var d = 0.8
				var random_color = Color(randf()/d, 1.5, randf()/d)
				# Set the albedo color
				material.albedo_color = random_color
	
