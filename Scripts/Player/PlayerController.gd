extends KinematicBody

onready var sprite = $AnimatedSprite3D

enum {
	WALKING,
	INTERACTING
}

#MOVEMENT
var speed = 7
const ACCEL_DEFAULT = 10
const ACCEL_AIR = 1
onready var accel = ACCEL_DEFAULT
var gravity = 9.8
var jump = 5
var snap
var angular_velocity = 30
var direction = Vector3()
var velocity = Vector3()
var gravity_vec = Vector3()
var movement = Vector3()

#INTERACTION
var allInteractions = []
var closestInteraction

#PLAYER
var playerState = WALKING

func _physics_process(delta):
	movePlayer(delta)
	
	if playerState == WALKING:
		rotateSprite()
		GetClosestInteractable()
		Interact()

func movePlayer(delta):
	#get keyboard input
	direction = Vector3.ZERO
	if playerState == WALKING:
		var f_input = Input.get_action_strength("move_back") - Input.get_action_strength("move_forward")
		var h_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		direction = Vector3(h_input, 0, f_input).normalized()
	
	#jumping and gravity
	if is_on_floor():
		snap = -get_floor_normal()
		accel = ACCEL_DEFAULT
		gravity_vec = Vector3.ZERO
	else:
		snap = Vector3.DOWN
		accel = ACCEL_AIR
		gravity_vec += Vector3.DOWN * gravity * delta
		
	if Input.is_action_just_pressed("move_jump") and is_on_floor() and playerState == WALKING:
		snap = Vector3.ZERO
		gravity_vec = Vector3.UP * jump
	
	#make it move
	velocity = velocity.linear_interpolate(direction * speed, accel * delta)
	movement = velocity + gravity_vec
	
	move_and_slide_with_snap(movement, snap, Vector3.UP)

func rotateSprite():
	if movement.x > 0:
		sprite.flip_h = true
	if movement.x < 0:
		sprite.flip_h = false

func GetClosestInteractable():
	if allInteractions.size() > 0:
		for interactable in allInteractions:
			if closestInteraction == null or interactable.global_transform.origin.distance_to(global_transform.origin) < closestInteraction.global_transform.origin.distance_to(global_transform.origin):
				closestInteraction = interactable

func Interact():
	if Input.is_action_just_pressed("interact"):
		if allInteractions.size() > 0:
			closestInteraction.Interact()
			PlayerStartInteracting()

func PlayerStartInteracting():
	playerState = INTERACTING

func PlayerDoneInteracting():
	playerState = WALKING


func _on_InteractionRange_body_entered(body):
	if body.has_method("Interact"):
		allInteractions.append(body)
		body.playerInRange = true
		body.player = self


func _on_InteractionRange_body_exited(body):
	if body.has_method("Interact"):
		allInteractions.remove(allInteractions.find(body))
		body.playerInRange = false
