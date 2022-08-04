extends TextureRect

var conversation
var charSpeed = 0.04
var sentence : String
var dialogue : String
var curChar : int
var maxChar : int
var curSentence : int
var maxSentence : int

var isTalking = false

onready var charTimer = $CharTimer
onready var audioTalk = $AudioTalk

onready var dialogueText = $Text
onready var dialogueName = $Name
onready var dialogueIcon = $CharacterIcon 

func _ready():
	hide()

func _physics_process(delta):
	if isTalking:
		if Input.is_action_just_pressed("next"):
			NextSentence()

func StartDialogue(converse):
	isTalking = true
	dialogue = ""
	UpdateText()
	conversation = converse
	curSentence = 0
	maxSentence = conversation.size()
	ShowDialogue(conversation)
	show()

func SetName(name):
	#Sets the name of the dialogue box to the given name
	dialogueName.text = name

func ShowDialogue(dialogue):
	#Sets the curChar to 0 because of a new sentence and
	#sets the timer on how fast the letters should appear
	curChar = 0
	charTimer.wait_time = charSpeed
	
	#Gets the correct translation of the given key and 
	#sets the maxChar to the length of that sentence
	SetName(dialogue[curSentence].name)
	var text = dialogue[curSentence].dialogue
	sentence = tr(text)
	maxChar = sentence.length()
	
	#Starts the process of showing the letters
	charTimer.start()
	
func UpdateText():
	#Updates the text on screen with the current sentence
	dialogueText.text = dialogue

func _on_CharTimer_timeout():
	if curChar < maxChar and isTalking == true:
		#Adds the next character to the dialogue and restarts the timer
		dialogue += sentence[curChar]
		if sentence[curChar] == ".":
			charTimer.wait_time = 0.5
		else:
			audioTalk.pitch_scale = rand_range(1 , 1.2)
			audioTalk.play()
			charTimer.wait_time = 0.04
		curChar += 1
		charTimer.start()
		UpdateText()

func NextSentence():
	if curSentence < maxSentence - 1:
		curSentence += 1
		dialogue = ""
		UpdateText()
		ShowDialogue(conversation)
	else:
		hide()
		get_tree().call_group("Player", "PlayerDoneInteracting")
		isTalking = false

#Goes to the next sentence
func _on_Button_pressed():
	NextSentence()
