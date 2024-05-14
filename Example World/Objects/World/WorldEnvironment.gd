extends Node

# Timer for the day cycle
var day_length = 60.0  # Day length in seconds
var time_of_day = 0.0  # Current time of day
@onready var environment : WorldEnvironment = $WorldEnvironment
func _ready():
	pass
	#$AnimationPlayer.play("DayCycle")

func _process(delta):
	pass 
	#environment.environment.sky.sky_material.set_shader_parameter("clouds_cutoff", clouds_cutoff)
func _on_Timer_timeout():
	# Reset the day cycle
	time_of_day = 0
