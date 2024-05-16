extends Node3D

# Timer for the day cycle
var day_length = 180.0  # Day length in seconds (how long a full 24-hour cycle takes in real time)
var time_of_day = 12.0  # Current time of day in hours
@onready var environment : WorldEnvironment = $WorldEnvironment
@onready var sunMoon = $DirectionalLight3D

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
	# Update the time of day
	time_of_day += (delta / day_length) * 24.0  # Increment time_of_day by the fraction of a day that has passed
	if time_of_day >= 24.0:
		time_of_day -= 24.0  # Normalize time of day after it reaches 24 hours
	
	
	# Calculate and set the rotation of the sun/moon light
	sunMoon.rotation_degrees.x = calculate_rotation(time_of_day)
	$AP/Clock.set_time(time_of_day)
