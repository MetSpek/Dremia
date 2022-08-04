extends Control

enum {
	RESUMED,
	PAUSED
}

var state = RESUMED
var canPause = true

func _ready():
	hide()

func _process(delta):
	if Input.is_action_just_pressed("pause") and canPause:
		if state == RESUMED:
			PauseGame()
		else:
			ResumeGame()

func PauseGame():
	get_tree().paused = true
	state = PAUSED
	show()

func ResumeGame():
	get_tree().paused = false
	state = RESUMED
	hide()

func stopAbilityToPause():
	canPause = false

func startAbilityToPause():
	canPause = true

func _on_Resume_pressed():
	ResumeGame()


func _on_Options_pressed():
	pass # Replace with function body.


func _on_MainMenu_pressed():
	pass # Replace with function body.


func _on_Exit_Game_pressed():
	get_tree().quit()
