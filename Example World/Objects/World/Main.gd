extends Node3D

# Timer for the day cycle
var day_length = 30.0  # Day length in seconds (how long a full 24-hour cycle takes in real time)
var time_of_day = 20.0  # Current time of day in hours
@onready var environment : WorldEnvironment = $WorldEnvironment
@onready var sunMoon = $DirectionalLight3D
var day = 0
var lanternLives=10
var death = false
var deathtimer=0
var spawn=true
var timepasses=true
# Helper function to calculate rotation based on current time
func calculate_rotation(current_time):
	var rotation
	if current_time < 6.0:  # From 0:00 to 6:00 interpolate between 90 degrees (24:00) and 200 degrees (6:00)
		rotation = lerp(90, 200, current_time / 6.0)
	elif current_time < 12.0:  # From 6:00 to 12:00 interpolate between 200 degrees (6:00) and 270 degrees (12:00)
		rotation = lerp(200, 270, (current_time - 6.0) / 6.0)
	elif current_time < 18.0:  # From 12:00 to 18:00 interpolate between 270 degrees (12:00) and 340 degrees (18:00)
		rotation = lerp(270, 340, (current_time - 12.0) / 6.0)
	else:  # From 18:00 to 24:00 interpolate between 340 degrees (18:00) and 450 degrees (24:00) (which is effectively 90 degrees)
		rotation = lerp(340, 450, (current_time - 18.0) / 6.0)
		if rotation >= 360:
			rotation -= 360  # Normalize rotation to stay within 0-359 degrees

	return rotation
func callCat():
	
	return
func _ready():
	pass


func _process(delta):
	 
	if death:
		
		deathtimer+=delta*5
		if deathtimer<0.5:
			get_node("cat").stuck=10
		if deathtimer<5:
			time_of_day -= (delta / day_length/2) * 24.0 
		if deathtimer>5 and time_of_day<3.0:
			time_of_day += (delta*5 / day_length) * 24.0 
		elif deathtimer>30 and deathtimer<35:
			
			if !State.catAtackTrigger:
				get_node("Player_Character").scale_var=get_node("Player_Character").scale_var_min
				get_node("Player_Character").fade(0.5)
				get_node("Player_Character").global_position=get_node("deathPlayerTrigger").global_transform.origin
				get_node("cat").global_position=get_node("deathCatTrigger").global_transform.origin
				time_of_day=3.0
				get_node("cat").sleeping=false
				get_node("cat").goSleep=false
				get_node("cat").target=get_node("Player_Character")
				get_node("cat").stop_radius=0.5
				
				State.catAtackTrigger=true
			else:
				get_node("Player_Character").CallCamera(get_node("cat"),delta,2.0)
		
	
	time_of_day += (delta / day_length) * 24.0 
	if time_of_day >= 24.0:
		if !death:
			day+=1
			spawn=true
		time_of_day -= 24.0 

	if time_of_day>0 and time_of_day<1 and spawn and !get_node("Player_Character").gameStart:
		get_node("EtScapeLook").spawn_et(day*day*2)
		spawn=false
	sunMoon.rotation_degrees.x = calculate_rotation(time_of_day)
	$AP/Clock.set_time(time_of_day)


func _on_colisor_body_entered(body):	
	if body.is_in_group("Et"):
		lanternLives-=1
		get_node("Lanterna/OmniLight3D").light_energy=get_node("Lanterna/OmniLight3D").light_energy-0.3
		get_node("Lanterna/OmniLight3D").omni_range=get_node("Lanterna/OmniLight3D").omni_range-0.3
		get_node("Lanterna/AudioStreamPlayer3D").play()
		if(lanternLives<=0):
			get_node("Player_Character").chapadao=5
			death=true
		body.queue_free()
		
		
