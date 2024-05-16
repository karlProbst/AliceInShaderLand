extends StaticBody3D

var needsWater=true

@onready var shader_code = load("res://Example World/Objects/World/High.gdshader")
@onready var green_texture = load("res://Textures/plant_green.png")
@onready var mid_texture = load("res://Textures/plant_mid.png")
@onready var dead_texture = load("res://Textures/plant_dead.png")
var coin_scene = preload("res://Assets 3d/Coin.tscn")
var shader_material
@export var Name = "Bed"
@onready var player = get_tree().get_root().get_node("World/Player_Character")
func _ready():
	print(get_child(0).global_transform.origin-position)
func watering():
	var pos = get_child(0).global_transform.origin-position
	needsWater=false
	for child in get_children():
		var material = null
		if not child is CollisionShape3D and not child.is_in_group("Coin"):
			material = child.material_override
			if material == null or not material is StandardMaterial3D:
				# Create a new StandardMaterial3D if none is attached
				material = StandardMaterial3D.new()
				child.material_override = material
			# Generate a random color
			var d = 0.8
			var random_color = Color(randf()/d, 1.2, randf()/d)
			# Set the albedo color
			material.albedo_color = random_color
			material.albedo_texture=green_texture
	spawn_coins(10,pos)
func PlayAction():
	
	if player.hasRegador and player.water>0:
		if has_node("AnimationPlayer"):
			$AnimationPlayer.play("ANIM")
		if needsWater:
			player.Regar()
			set_shader()
			watering()
func set_shader():
	var mesh_instance = $Mesh


func spawn_coins(n,locationVec):
	for i in range(n):
		var coin = coin_scene.instantiate()
		add_child(coin)  # Add coin to the scene tree
		coin.set_global_position(locationVec) # Randomize the spawn location
		var impulse = Vector3(randf_range(-1, 1), randf_range(0, 0.5), randf_range(-1, 1))
		# Apply an initial upward force
		coin.apply_impulse(impulse, impulse)  # Adjust the range as needed




