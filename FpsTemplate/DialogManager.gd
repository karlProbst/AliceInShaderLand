extends Node

var dialogue_balloon_scene : PackedScene

func _ready():
	pass

func show_dialogue_balloon(target_node: Node, text: String):


	var label = dialogue_balloon.get_node("Label")  # Adjust the path if necessary
	label.text = text

	# Position the balloon above the target node
	var target_global_pos = target_node.global_transform.origin
	var screen_pos = get_viewport().get_camera().unproject_position(target_global_pos)
	dialogue_balloon.rect_position = screen_pos + Vector2(0, -50)  # Adjust the offset as needed

	# Optional: Add some animation or timing to hide the balloon after some time
	#dialogue_balloon.queue_free()
