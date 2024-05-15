extends Node

var dialogue_balloon_scene = preload("res://Scenes/DialogueBalloon.tscn")

func show_dialogue_balloon(target_node: Node, text: String):
	var dialogue_balloon = dialogue_balloon_scene.instance()
	add_child(dialogue_balloon)

	dialogue_balloon.set_text(text)

	# Position the balloon above the target node
	var target_global_pos = target_node.global_transform.origin
	var screen_pos = get_viewport().get_camera().unproject_position(target_global_pos)
	dialogue_balloon.rect_position = screen_pos + Vector2(0, -50)  # Adjust the offset as needed

	# Optional: Hide the balloon after some time
	  # Balloon will disappear after 3 seconds
	dialogue_balloon.queue_free()
