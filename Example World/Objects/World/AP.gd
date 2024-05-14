extends Node3D

func _ready():
	Recolor()
	
func Recolor():
	var noise_texture = NoiseTexture2D.new()
	noise_texture.width = 512  # Set the desired width
	noise_texture.height = 512  # Set the desired height
	noise_texture.noise = FastNoiseLite.new()  # Use OpenSimplexNoise
	noise_texture.noise.domain_warp_fractal_octaves = 4
	noise_texture.noise.frequency=randf()/10
	noise_texture.noise.noise_type=1
	noise_texture.noise.fractal_type=3
	# Iterate over all children of this node
	#var d = (randf()*7)+0.8
	var d = randf_range(0.6,3.0)
	print(d)
	for child in get_children():
		if child is MeshInstance3D:
			# Check if the material is a StandardMaterial3D or if material needs to be created
			var material = child.material_override
			if material == null or not material is StandardMaterial3D:
				# Create a new StandardMaterial3D if none is attached
				material = StandardMaterial3D.new()
				child.material_override = material

			# Generate a random color
			
			var random_color = Color(randf() / d, randf() / d, randf() / d)
			material.albedo_color = random_color
			
					# Create and configure a noise texture
		
		
			
			# Apply the noise texture to the material's albedo texture
			material.albedo_texture = noise_texture
