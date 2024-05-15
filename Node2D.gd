extends Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
var gato = preload("res://Dialog/Gato.dialogue")
func _ready():
	DialogueManager.show_example_dialogue_balloon(gato,"start")
	pass
