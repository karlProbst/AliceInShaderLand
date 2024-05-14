extends Sprite3D


func _on_timer_timeout():
	queue_free()


func _on_rigid_body_3d_body_entered(body):
	# Check if the colliding body is part of the "ray" group
	if body.is_in_group("Coin"):
		queue_free()  # Free the coin if it hits any node in the "ray" group
