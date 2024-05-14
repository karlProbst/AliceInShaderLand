@tool
extends MeshInstance3D

@export var xSize = 20
@export var zSize = 20
var Terrain_Size 
@export var update = false
@export var clear_ver_vis = false
var create_collision = true
var min_height = 0
var max_height = 0

var offset = 0.0
# Called when the node enters the scene tree for the first time.
func _ready():
	generate_terrain(offset)

var vertices = []  # Store vertices here

func generate_terrain(offset):
	var a_mesh:ArrayMesh
	var surftool = SurfaceTool.new()
	var n = FastNoiseLite.new()
	n.noise_type = FastNoiseLite.TYPE_PERLIN
	n.frequency = 0.03
	n.offset.x += offset
	surftool.begin(Mesh.PRIMITIVE_TRIANGLES)

	# Clear the vertices array
	vertices = []

	for z in range(zSize+1):
		for x in range(xSize+1):
			var y = n.get_noise_2d(x*0.5,z*0.5)*10
			# Set min and max
			if y < min_height and y != null:
				min_height = y
			if y > max_height and y != null:
				max_height = y

			var uv = Vector2()
			uv.x = inverse_lerp(0, xSize, x)
			uv.y = inverse_lerp(0, zSize, z)

			surftool.set_uv(uv)
			var vertex = Vector3(x * 20, y * 20, z * 20)
			surftool.add_vertex(vertex)
			
			# Store each vertex
			vertices.append(vertex)

	var vert = 0
	for z in zSize:
		for x in xSize:
			surftool.add_index(vert+0)
			surftool.add_index(vert+1)
			surftool.add_index(vert+xSize+1)
			surftool.add_index(vert+xSize+1)
			surftool.add_index(vert+1)
			surftool.add_index(vert+xSize+2)
			vert += 1
		vert += 1
	surftool.generate_normals()
	a_mesh = surftool.commit()
	mesh = a_mesh
	update_shader()
	if create_collision:
		clear_collision()

		var collision_shape = CollisionShape3D.new()
		var convex_shape = ConvexPolygonShape3D.new()

		# Use the stored vertices
		convex_shape.set_points(vertices)

		collision_shape.shape = convex_shape
		add_child(collision_shape)

func generate_collision():
	clear_collision()
	create_trimesh_collision()
	
func update_shader():
	var mat = get_active_material(0)
	#mat.set_shader_parameter("min_height", min_height)
	#at.set_shader_parameter("max_height", max_height)

func _process(delta):
	
	Terrain_Size = xSize
	if update:
		offset+=delta*10
		generate_terrain(offset)
		update=false
		
	if clear_ver_vis:
		for i in get_children():
			i.free()

func draw_sphere(pos:Vector3):
	var ins = MeshInstance3D.new()
	add_child(ins)
	ins.position = pos
	var sphere = SphereMesh.new()
	sphere.radius = 0.1
	sphere.height = 0.2
	ins.mesh = sphere
	
	

func clear_collision():
	if get_child_count() > 0:
		for i in get_children():
			i.free()



func _on_timer_timeout():
	update=true
	
