extends Control


onready var tabContainer = $TabContainer
var player

var maxTabs

func _ready():
	maxTabs = tabContainer.get_tab_count()
	player = get_parent().get_parent()
	hide()

func _process(delta):
	if player.playerState == 0:
		if Input.is_action_just_pressed("open_party"):
			OpenParty()
		elif Input.is_action_just_pressed("open_inventory"):
			OpenInventory()
		elif Input.is_action_just_pressed("open_map"):
			OpenMap()
	if Input.is_action_just_pressed("pause") and tabContainer.visible == true:
		HideMenu()
	if Input.is_action_just_pressed("next_tab"):
		if visible == true:
			if tabContainer.current_tab == maxTabs - 1:
				tabContainer.current_tab = 0
			else:
				tabContainer.current_tab += 1
		else:
			showMenu()

func OpenParty():
	tabContainer.current_tab = 0
	showMenu()

func OpenInventory():
	tabContainer.current_tab = 1
	showMenu()

func OpenMap():
	tabContainer.current_tab = 2
	showMenu()

func showMenu():
	show()
	get_tree().call_group("Player", "PlayerStartInteracting")
	get_tree().call_group("PauseMenu", "stopAbilityToPause")

func HideMenu():
	hide()
	get_tree().call_group("Player", "PlayerDoneInteracting")
	get_tree().call_group("PauseMenu", "startAbilityToPause")
