extends Node3D

func set_time(time: float) -> void:

	time = clamp(time, 0.0, 24.0)
	
	var degrees = -30*time+720


	degrees = fposmod(degrees, 360.0)


	$Hand.rotation_degrees.z = degrees

