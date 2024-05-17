extends StaticBody3D

var needsWater=true
@onready var player = get_tree().get_root().get_node("World/Player_Character")
@onready var cat = get_tree().get_root().get_node("World/cat")
@onready var frontOfSink = get_tree().get_root().get_node("World/FrontOfSinkTrigger")
var Name="PORTA"
@onready var corredorMusic = get_tree().get_root().get_node("World/Player_Character/CorredorMusic")
@onready var apMusic = get_tree().get_root().get_node("World/Player_Character/ApMusic")

var scriptTimer=0
@onready var gameScript=preload("res://Dialog/Script.dialogue")
var dialog = false
func _physics_process(delta):
	
	if State.enteringApTrigger:
		scriptTimer+=delta
		State.stuck=0.1
		if scriptTimer>5:
			#entrando ap automticamente
			if(move_towards_target(delta,player,frontOfSink.global_transform.origin)):
				
				player.CallCamera(cat,delta,10.0,10.0)
				#musica abaixa
			if corredorMusic.volume_db>-40:
				corredorMusic.volume_db-=delta*20
			else:
			#falando com gato
				if apMusic.volume_db<=-20:
					$AnimationPlayer.play("Fechando")
					apMusic.play()
					apMusic.volume_db+=delta*5
				else:
					if apMusic.volume_db<-8:
						apMusic.volume_db+=delta*.15
					if !dialog:
						DialogueManager.show_example_dialogue_balloon(gameScript,"start")
						dialog=true
	elif dialog:
		if apMusic.volume_db<-8:
			apMusic.volume_db+=delta*.15
		else:
			dialog = true			
func PlayAction():
	if has_node("AnimationPlayer"):
		$AnimationPlayer.play("Abrindo")
	self.remove_from_group("Interactible")
	$CollisionShape3D.queue_free()
	State.enteringApTrigger=true
func set_shader():
	var mesh_instance = $Mesh


func move_towards_target(delta,node,target_position):
	var current_position = node.global_transform.origin
	var distance = current_position.distance_to(target_position)
	var move_vector
	var move_speed=0.03
	var direction
	if distance > 0.1:  # Check if the player is close enough to the target position
		direction = (target_position - current_position).normalized()
		move_vector = direction * move_speed * delta

	# Ensure the player does not overshoot the target
	
		move_vector = direction * distance

		node.global_transform.origin += move_vector*delta
	else:
		return true




