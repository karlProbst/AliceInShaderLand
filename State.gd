# Handles game states
extends Node

var hasRegador = "no"  # Possible states: "no", "has", "no water"
var stuck=false
var world
var enteringApTrigger=false
var catAtackTrigger=false
var catAtackTriggerLock = false
@onready var gameScript=preload("res://Dialog/Script.dialogue")
func _ready():
	world = get_world()
	
func set_hasRegador(status):
	
	if status in ["no", "has", "no water"]:
		hasRegador = status
	else:
		print("Invalid status for hasRegador")


func _process(delta):
	if enteringApTrigger:
		world.get_node("cat").stuck=1.0
		world.timepasses=true
	if stuck:
		world.get_node("Player_Character").stuck=0.1
		world.get_node("Player_Character").cursortrue=0.1
	if catAtackTrigger:
		if !catAtackTriggerLock:
			DialogueManager.show_example_dialogue_balloon(gameScript,"gatoMortal")
			catAtackTriggerLock=true
		world.get_node("cat").stuck=1
	else:
		catAtackTriggerLock=false
	
func get_world() -> Node:
	var root = get_tree().root
	var world = root.get_node("World")
	if world:
		return world
	else:
		print("World node not found.")
		return null

func Reseta():
	world = get_world()
	stuck=false
	enteringApTrigger=false
	catAtackTrigger=false
	catAtackTriggerLock = false
	hasRegador = "no"
