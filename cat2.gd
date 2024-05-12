extends CharacterBody3D

var max_speed: float = 4.0
var current_speed: float = 0.0
var acceleration: float = 0.4
var deceleration: float = 1.5
var rotation_speed: float = 3.0
var gravity: float = -9.8
var stop_radius: float = 2.0
var stuck_timer: float = 0.0
var is_stuck: bool = false
var random_run_duration: float = 0.0
var random_direction: Vector3 = Vector3.ZERO  # Persistent storage for random direction

@onready var target: Node = get_parent().get_node("Player_Character")
@onready var raycastr: RayCast3D = $RayCast3DR
@onready var raycastl: RayCast3D = $RayCast3DL
@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _physics_process(delta):
	if target:
		if velocity.length() < max_speed * 0.01:
			stuck_timer += delta

		var target_position = target.global_transform.origin
		var distance_to_target = global_transform.origin.distance_to(target_position)
		var direction = (target_position - global_transform.origin).normalized()
		var flat_direction = Vector3(direction.x, 0, direction.z).normalized()

		if distance_to_target < stop_radius:
			Touching()
			switch_animation("Idle", 1.0)
			stuck_timer=0
		elif velocity.length()<0.1:
			stuck_timer+=delta*2
		elif not is_stuck:
			stuck_timer=0
			
		raycastr.force_raycast_update()
		raycastl.force_raycast_update()
		
	
		if(stuck_timer>3):
			random_run_duration = randf_range(0.5, 3.0)
			random_direction = Vector3(randf() * 2 - 1, 0, randf() * 2 - 1).normalized()
			is_stuck=true
			
		if(is_stuck):
			handle_stuck(delta, flat_direction,random_run_duration,random_direction)
		

			


		# Calculate final velocity considering the current speed and direction
	
		velocity = flat_direction * current_speed
		velocity.y += gravity * delta
		
		move_and_slide()
		# Animation and rotation
		if velocity.length() > 0.01:
			var speed_scale = current_speed / max_speed  # Calculate speed scale
			switch_animation("ArmatureAction", speed_scale)
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
			switch_animation("referenceAction", 1.0)
		

func handle_stuck(delta, flat_direction,duration,dir):

	current_speed = min(current_speed + acceleration * delta, max_speed)  # Accelerate on straight paths
	random_direction = Vector3.ZERO  # Clear random direction
	if(raycastl.is_colliding() or raycastr.is_colliding()):
		is_stuck = false
	current_speed = max_speed  # Set speed to max to initiate movement

	if random_run_duration > 0:
		random_run_duration -= delta
	else:
		is_stuck = false
		stuck_timer = 0

func update_animation(velocity):
	if velocity.length() > 0.01:
		var speed_scale = velocity.length() / max_speed
		switch_animation("Run", speed_scale)
	else:
		switch_animation("Idle", 1.0)

func switch_animation(animation_name: String, speed_scale: float):
	if anim_player.current_animation != animation_name or anim_player.speed_scale != speed_scale:
		anim_player.play(animation_name)
		anim_player.speed_scale = speed_scale

func Touching():
	# Define what happens when the cat touches or is very close to the player
	pass
