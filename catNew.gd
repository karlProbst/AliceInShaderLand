extends CharacterBody3D

var max_speed: float = 4.0  # Maximum speed at which the cat can move
var current_speed: float = 0.0  # Current speed of the cat, starts at 0
var acceleration: float = 0.4  # Acceleration rate when on a straight path
var deceleration: float = 1.5  # Deceleration rate when turning
var rotation_speed: float = 3.0  # Speed of rotation towards the velocity direction
var gravity: float = -9.8  # Acceleration due to gravity (m/s^2)
var stop_radius: float = 2.0  # Distance at which the cat stops moving towards the player
var stuck_timer: float = 0.0  # Timer to track if the cat is stuck
var is_stuck: bool = false  # Flag to check if the cat is stuck
var random_run_duration: float = 0.0  # Duration for running in a random direction
var low_velocity_timer = 0.0
var spd =  0
@onready var target: Node = get_parent().get_node("Player_Character")
@onready var raycastr: RayCast3D = $RayCast3DR
@onready var raycastl: RayCast3D = $RayCast3DL
@onready var raycast: RayCast3D = $RayCast3D
@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _physics_process(delta):
	if target:
		var target_position = target.global_transform.origin
		var distance_to_target = global_transform.origin.distance_to(target_position)
		var direction = (target_position - global_transform.origin).normalized()
		var flat_direction = Vector3(direction.x, 0, direction.z).normalized()

		if distance_to_target < stop_radius:
			Touching()
			switch_animation("Idle", 1.0)
			return  # Stop processing if within stop radius

		raycast.force_raycast_update()
		var move_direction = flat_direction
		var avoidance_force = Vector3.ZERO
		if raycast.is_colliding():
			var hit_normal = raycast.get_collision_normal()
			avoidance_force = hit_normal * max_speed
			move_direction = (flat_direction + avoidance_force).normalized()

		current_speed = min(current_speed + acceleration * delta, max_speed)  # Accelerate on straight paths

	
		# Check velocity magnitude
		if velocity.length() < max_speed * 0.01:
			low_velocity_timer += delta
		else:
			low_velocity_timer = 0
		
		if low_velocity_timer > 0.5 and distance_to_target > stop_radius:
			rotate_y(delta * rotation_speed)  # Rotate the cat
			current_speed+=delta
		####
		
		velocity.x = move_direction.x * current_speed 
		velocity.z = move_direction.z * current_speed
		velocity.y += gravity * delta
		move_and_slide()

		# Animation and rotation
		if velocity.length() > 0.01:
			var speed_scale = current_speed / max_speed  # Calculate speed scale
			switch_animation("Run", speed_scale)
			var actual_direction = Vector3(velocity.x, 0, velocity.z).normalized()
			var flat_current = Vector3(global_transform.basis.z.x, 0, global_transform.basis.z.z).normalized()
			var rotation_angle = flat_current.angle_to(actual_direction)

			if rotation_angle > 0.001 or rotation_angle < -0.001:
				var rotation_axis = Vector3.UP
				if flat_current.cross(actual_direction).y < 0:
					rotation_angle = -rotation_angle
				rotation_angle -= PI / 2
				global_transform.basis = global_transform.basis.rotated(rotation_axis, rotation_angle * rotation_speed * delta)
		else:
			switch_animation("Idle", 1.0)

func switch_animation(animation_name: String, speed_scale: float):
	if anim_player.current_animation != animation_name or anim_player.speed_scale != speed_scale:
		anim_player.play(animation_name)
		anim_player.speed_scale = speed_scale*4.0

func Touching():
	# Define what happens when the cat touches or is very close to the player
	pass