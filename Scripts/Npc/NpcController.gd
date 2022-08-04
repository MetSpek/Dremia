extends KinematicBody

export var NpcName : String
export var conversation : Array

var playerInRange = false
var player

onready var sprite = $AnimatedSprite3D

func _physics_process(delta):
	if playerInRange:
		RotateToPlayer()

func Interact():
	get_tree().call_group("Dialogue", "StartDialogue", conversation)

func RotateToPlayer():
	if player.global_transform.origin.x < global_transform.origin.x:
		sprite.flip_h = false
	else:
		sprite.flip_h = true
