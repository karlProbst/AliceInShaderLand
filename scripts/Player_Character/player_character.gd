extends CharacterBody3D

@onready var Camera = get_node("%Camera")
@export var animation_tree: AnimationTree
@onready var shader_code = load("res://Example World/Objects/World/High.gdshader")
#const SPEED = 5.0
var _speed: float
const JUMP_VELOCITY = 1.5

var CameraRotation: Vector2 = Vector2(0.0,0.0)
var MouseSensitivity = 0.0032
var sensitivity_min = 0.0009
var sensitivity_max = 0.009

var shake_rotation = 0 
var Start_Shake_Rotation = 0
#CUSTOM
@onready var rayInt = $Camera/RayInt
@onready var rayIntLong = $Camera/RayInt2
@onready var uiInt = $Ui/Interaction
var meshnode
var int_node_array := []



var isInteractive = false



var paused=false
@export_category("Lean Parametres")
@export_range(0.0,1.0) var Lean_Speed: float = .2
@export var Right_Lean_Collision: ShapeCast3D
@export var Left_Lean_Collision: ShapeCast3D
var lean_tween
enum {LEFT = 1, CENTRE = 0, RIGHT = -1}

@export_category("Speed Parameters")
@export var Sprint_Timer: Timer
#@export var Sprint_Cooldown_Timer: Timer

@export var Sprint_Cooldown_Time: float = 3.0
@export var Sprint_Time: float = 1.0
@export var Sprint_Replenish_rate: float = 0.30
var Sprint_On_Cooldown: bool = false
var Sprint_Time_Remaining: float = Sprint_Time
@onready var Sprint_Bar: Range = $Ui/Sprint_Bar

const NORMAL_SPEED = 1
@export_range(1.0,3.0) var Sprint_Speed: float = 2.0
@export_range(0.1,1.0) var Walk_Speed: float = 0.5
var Speed_Modifier: float = NORMAL_SPEED

@export_category("Jump Parameters")
@export var Jump_Peak_Time: float = .5
@export var Jump_Fall_Time: float = .5
@export var Jump_Height: float = 2.0
@export var Jump_Distance: float = 4.0
@export var Coyote_Time: float = .1
@export var Jump_Buffer_Time: float = .2
@onready var coyote_timer: Timer = $Coyote_Timer



# Get the gravity from the project settings to be synced with RigidBody nodes.
var Jump_Gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var Fall_Gravity: float
var Jump_Velocity: float
var Speed: float
var Jump_Available: bool = true
var Jump_Buffer: bool = false
var hit_location = Vector3.ZERO
var scale_var

var chapadao = 0
func _ready():
	$Camera/glassass.mesh.material.set_shader_parameter("distortion_size",0)
	$Camera/glassass/AnimationPlayer.play("offset")
	scale_var=scale

	Update_CameraRotation()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Calculate_Movement_Parameters()

func Update_CameraRotation():
	var current_rotation = get_rotation()
	CameraRotation.x = current_rotation.y
	CameraRotation.y = current_rotation.x

func StartMenu():
	
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		paused=true
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		paused=false
	if(paused):
		$Ui/Start.visible=true
		$Ui/Hit_Sight.visible=false
		$Ui/Interaction.visible=false
		$Ui/Main_Sight.visible=false
		$Ui/BlurVignette.material.set_shader_parameter("blur_radius", 1)
		$Ui/BlurVignette.material.set_shader_parameter("blur_amount", 5.0)
	else:
		$Ui/BlurVignette.material.set_shader_parameter("blur_radius", 0.2)
		$Ui/BlurVignette.material.set_shader_parameter("blur_amount", 1.0)
		$Ui/Start.visible=false
		$Ui/Main_Sight.visible=true
		$Ui/Interaction.visible=true
func _input(event):
	
	if event.is_action_pressed("ui_cancel"):
		StartMenu()
	if(!paused):
		

		if event is InputEventMouseMotion:
			var MouseEvent = event.relative * MouseSensitivity
			CameraLook(MouseEvent)
			
	
		
			
		if Input.is_action_just_released("lean_left") or Input.is_action_just_released("lean_right"):
			if !(Input.is_action_pressed("lean_right") or Input.is_action_pressed("lean_left")):
				pass
		if Input.is_action_just_pressed("lean_left"):
			if scale_var.x>0.1:
				
				self.scale/=2
				scale_var/=2
				Jump_Height=scale_var.x/200
				Jump_Distance=scale_var.x/500
				Jump_Peak_Time=scale_var.x/500
			
		if Input.is_action_just_pressed("lean_right"):
			if isInteractive:
				print("node:", isInteractive.Name)
				
				if isInteractive.has_method("PlayAction"):
					isInteractive.PlayAction()
					chapadao+=1
					print("LJJLDJKD")
			
		if Input.is_action_just_released("sprint") or Input.is_action_just_released("walk"):
			if !(Input.is_action_pressed("walk") or Input.is_action_pressed("sprint")):
				Speed_Modifier = NORMAL_SPEED
				exit_sprint()

		if Input.is_action_just_pressed("sprint"):
			if !Sprint_On_Cooldown:
				Speed_Modifier = Sprint_Speed
				Sprint_Timer.start(Sprint_Time_Remaining)

		if Input.is_action_just_pressed("walk"):
			Speed_Modifier = Walk_Speed

func Calculate_Movement_Parameters()->void:
	Jump_Gravity = (2*Jump_Height)/pow(Jump_Peak_Time,2)
	Fall_Gravity = (2*Jump_Height)/pow(Jump_Fall_Time,2)
	Jump_Velocity = Jump_Gravity * Jump_Peak_Time
	Speed = Jump_Distance/(Jump_Peak_Time+Jump_Fall_Time)
	_speed = Speed



	
func exit_sprint():
	if !Sprint_Timer.is_stopped():
		Sprint_Time_Remaining = Sprint_Timer.time_left
		Sprint_Timer.stop()

func Sprint_Replenish(delta):
	var Sprint_Bar_Value

	if !Sprint_On_Cooldown and (Speed_Modifier != Sprint_Speed):
		
		if is_on_floor():
			Sprint_Time_Remaining = move_toward(Sprint_Time_Remaining, Sprint_Time, delta*Sprint_Replenish_rate)
			
		Sprint_Bar_Value= (Sprint_Time_Remaining/Sprint_Time)*100
		
	else:
		Sprint_Bar_Value = (Sprint_Timer.time_left/Sprint_Time)*100
	
	#Sprint_Bar_Value = ((int(Sprint)*Sprint_Time_Remaining)+(int(!Sprint)*Sprint_Timer.time_left)/Sprint_Time)*100
	Sprint_Bar.value = Sprint_Bar_Value
	
	if Sprint_Bar_Value == 100:
		Sprint_Bar.hide()
	else:
		Sprint_Bar.show()
		
func ShowInteraction(isInteractible,node,hitLocation):
	
	if !int_node_array.is_empty():
	
		for i in int_node_array:
			i.material_overlay = null
			int_node_array.erase(i)
			
	if(isInteractible):
		isInteractive=node
		hit_location=hitLocation
		meshnode = node.get_child(0)
		int_node_array.append(meshnode)
		meshnode.material_overlay = ShaderMaterial.new()
		meshnode.material_overlay.shader = shader_code
		
	else:
		for i in int_node_array:
			i.material_overlay = null
			int_node_array.erase(i)

	uiInt.visible=isInteractible
func add_audio_effect(audio_source, effect,intensity):
	# Create an instance of AudioEffectEcho
	if(AudioServer.get_bus_effect_count(audio_source)==0):
		var echo_effect = AudioEffectDelay.new()
		echo_effect.feedback_active=true
		echo_effect.feedback_delay_ms=intensity*3.0
		AudioServer.add_bus_effect(audio_source,echo_effect,-1)
		var phaser_effect = AudioEffectPhaser.new()
		phaser_effect.depth=0.3
		phaser_effect.feedback=0.7
		AudioServer.add_bus_effect(audio_source,phaser_effect,-1)
	# et parameters for the echo effect
	

func remove_all_audio_effects(audio_source):
	for i in range(AudioServer.get_bus_effect_count(audio_source)):
		AudioServer.remove_bus_effect(audio_source,i) # Remove effect at index 0
func _physics_process(delta):
	
	if(chapadao>0):
		add_audio_effect(AudioServer.get_bus_index("Music"), 6,chapadao)
		var d = $Camera/glassass.mesh.material.get_shader_parameter("distortion_size")
		if(d<chapadao):
			d+=delta/14
		else:
			d-=delta
		$Camera/glassass.mesh.material.set_shader_parameter("distortion_size",d)
		chapadao-=delta/14
		
	else:
		remove_all_audio_effects(AudioServer.get_bus_index("Music"))
		$Camera/glassass.mesh.material.set_shader_parameter("distortion_size",0)
	#if(hit_location!=Vector3.ZERO):
	#	var distance_to_hit = global_transform.origin.distance_to(hit_location)
	#	print(distance_to_hit)
	#	if distance_to_hit > 2:
	#		print("distance_to_hit")


	if(!paused):
		if rayInt.is_colliding():
			var collision = rayInt.get_collider()
			if collision.is_in_group("Interactible"):
				
				ShowInteraction(true,collision,rayInt.get_collision_point())
			else:
				ShowInteraction(false,false,Vector3.ZERO)
		else:
			ShowInteraction(false,false,Vector3.ZERO)
			
		Sprint_Replenish(delta)

	

		# Add the gravity.
		if not is_on_floor():
			if coyote_timer.is_stopped():
				coyote_timer.start(Coyote_Time)
		
			if velocity.y>0:
				velocity.y -= Jump_Gravity * delta
			else:
				velocity.y -= Fall_Gravity * delta
		else:
			Jump_Available = true
			coyote_timer.stop()
			_speed = (Speed / Speed_Modifier*scale_var.x)
			$Camera/lean_pivot/MainCamera.fov=88+(1-scale_var.x)*15
			if Jump_Buffer:
				Jump()
				Jump_Buffer = false
		
		# Handle Jump.
		if Input.is_action_just_pressed("ui_accept"):
			if Jump_Available:
				Jump()
			else:
				Jump_Buffer = true
				get_tree().create_timer(Jump_Buffer_Time).timeout.connect(on_jump_buffer_timeout)

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

		velocity.x = move_toward(velocity.x, direction.x * _speed, Speed)
		velocity.z = move_toward(velocity.z, direction.z * _speed, Speed)
		
		move_and_slide()

func Jump()->void:
	velocity.y = Jump_Velocity
	Jump_Available = false

func _on_sprint_timer_timeout() -> void:
	Sprint_On_Cooldown = true
	get_tree().create_timer(Sprint_Cooldown_Time).timeout.connect(_on_sprint_cooldown_timeout)
	Speed_Modifier = NORMAL_SPEED
	Sprint_Time_Remaining = 0

func _on_sprint_cooldown_timeout():
	Sprint_On_Cooldown = false


func _on_coyote_timer_timeout() -> void:
	Jump_Available = false

func on_jump_buffer_timeout()->void:
	Jump_Buffer = false


func _on_music_vol_slider_value_changed(value):
	
	var min_db = -40
	var max_db = 0
	var volume_db = lerp(min_db, max_db, value/100)  # Assuming value ranges from 0 to 1
	if(value==0):
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), -80)
	else:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), volume_db)



func _on_fx_vol_slider_value_changed(value):
	var min_db = -40
	var max_db = 0
	var volume_db = lerp(min_db, max_db, value/100)  # Assuming value ranges from 0 to 1
	if(value==0):
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Fx"), -80)
	else:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Fx"), volume_db)


func _on_sen_slider_value_changed(value):
	ChangeSen(value)
func ChangeSen(value):
	
	
	var normalized_value = (value - 1) / (100 - 1)  # Normalize value between 0 and 1
	var mapped_sensitivity = lerp(sensitivity_min, sensitivity_max, normalized_value)
	MouseSensitivity = mapped_sensitivity
	
func CameraLook(Movement: Vector2):
	
	CameraRotation += Movement
	
	transform.basis = Basis()*scale_var.x
	Camera.transform.basis = Basis()
	
	rotate_object_local(Vector3(0,1,0),-CameraRotation.x) # first rotate in Y
	Camera.rotate_object_local(Vector3(1,0,0), -CameraRotation.y) # then rotate in X
	CameraRotation.y = clamp(CameraRotation.y,-1.5,1.2)
	

func CallCamera2(node, delta, speed):
	var target_dir = (node.global_transform.origin - global_transform.origin).normalized()
	var target_rot = Basis().looking_at(target_dir, Vector3(0, 1, 0))
	global_transform.basis = global_transform.basis.slerp(target_rot, speed * delta)

	var rotation = self.global_transform.basis.get_euler()

	# Extract yaw and pitch angles from the rotation
	var yaw = 0
	var pitch = rotation.x

	# Set CameraRotation to the extracted angles
	CameraRotation = Vector2(yaw, pitch)
	Update_CameraRotation()
	
func CallCamera(target_node: Node, delta: float, base_speed: float, max_rotation_speed: float = 0.1):
	# Get the target node's global position
	var target_global_position = target_node.global_transform.origin
	var player_rotation_y = rotation.y
	# Get the player's forward direction based on rotation
	var player_forward = Vector3(sin(player_rotation_y), 0, cos(player_rotation_y))
	# Calculate the direction to the target node
	var direction_to_target = global_transform.origin - target_global_position
	direction_to_target.y = 0  # Ensure no vertical movement
	# Add a small epsilon to denominator to avoid division by zero
	var denominator = direction_to_target.x + 0.0001
	# Calculate the angle between player's forward direction and direction to target
	var angle_to_target = atan2(direction_to_target.z, denominator) - atan2(player_forward.z, player_forward.x)
	# Smoothly rotate towards the angle to the target
	CameraLook(Vector2(angle_to_target / 10, 0))









	
