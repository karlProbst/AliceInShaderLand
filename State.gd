# Handles game states
extends Node

var hasRegador = "no"  # Possible states: "no", "has", "no water"
var stuck=false
var world
var enteringApTrigger=false

func _ready():
	world = get_world()
func set_hasRegador(status):
	
	if status in ["no", "has", "no water"]:
		hasRegador = status
	else:
		print("Invalid status for hasRegador")


func _process(delta):
	if stuck:
		world.get_node("Player_Character").stuck=0.1
		world.get_node("Player_Character").cursortrue=0.1
func get_world() -> Node:
	var root = get_tree().root
	var world = root.get_node("World")
	if world:
		return world
	else:
		print("World node not found.")
		return null
