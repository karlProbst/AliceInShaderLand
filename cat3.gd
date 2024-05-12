extends CharacterBody3D

var max_speed: float = 4.0
var current_speed: float = 0.0
var acceleration: float = 0.4
var deceleration: float = 1.5
var rotation_speed: float = 3.0
var gravity: float = -9.8
var stop_radius: float = 2.0
var low_velocity_timer: float = 0.0  # Timer for low velocity checks
var min_velocity_threshold: float = max_speed * 0.01  # 1% of max speed

@onready var target: Node = get_parent().get_node("Player_Character")
@onready var raycastr: RayCast3D = $RayCast3DR
@onready var raycastl: RayCast3D = $RayCast3DL
@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _physics_process(delta):
	var target_position = target.global_transform.origin
	var distance_to_target = global_transform.origin.distance_to(target_position)
	var direction = (target_position - global_transform.origin).normalized()
	var flat_direction = Vector3(direction.x, 0, direction.z).normalized()

	if distance_to_target < stop_radius:
		Touching()
		switch_animation("Idle", 1.0)
		return  # Stop processing if within stop radius

	raycastr.force_raycast_update()
	raycastl.force_raycast_update()
	var move_direction = flat_direction

	if raycastr.is_colliding():
		move_direction = (flat_direction + Vector3(-0.2, 0, 0)).normalized()
		current_speed = max(current_speed - deceleration * delta, 0)
	if raycastl.is_colliding():
		move_direction = (flat_direction + Vector3(0.2, 0, 0)).normalized()
		current_speed = max(current_speed - deceleration * delta, 0)

	# Velocity handling
	var velocity = move_direction * current_speed
	velocity.y += gravity * delta
	move_and_slide()
	
	# Check velocity magnitude
	if velocity.length() < min_velocity_threshold:
		low_velocity_timer += delta
	else:
		low_velocity_timer = 0

	# If velocity is too low for too long, rotate and move
	if low_velocity_timer > 0.5 and distance_to_target > stop_radius:
		rotate_y(delta * rotation_speed)  # Rotate the cat
	print(low_velocity_timer)

	update_animation(velocity)

func update_animation(velocity: Vector3):
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
	# Logic for what happens when the cat is close to the player
	pass
