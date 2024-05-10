extends Node3D
@onready var player= get_parent().get_node("Player_Character")

# Called when the node enters the scene tree for the first time.
func _ready():
	print(player)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_accept"):
		player.CallCamera(self,10.0,delta)
