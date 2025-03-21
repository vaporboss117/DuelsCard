extends Node2D

const CARD_SCENE_PATH = "res://Scenes/card.tscn"
const CARD_DRAW_SPEED = 0.2


var player_ref
# var player_deck = ["Knight","Knight","Archer","Demon","Demon","Demon","Archer","Archer","Archer","Archer","Knight","Knight","Knight"]
var player_deck = ["Felanie thief","Reckless barbarian","Felanie thief","Felanie thief","Felanie thief","Reckless barbarian","Reckless barbarian","Reckless barbarian","Reckless barbarian"]
var card_database_reference
var mana = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_deck.shuffle()
	$CardAmount.text = str(player_deck.size())
	card_database_reference = preload("res://Scripts/CardDatabase.gd")
	player_ref = $".."
	$ManaAmount.text = str(str(player_ref.mana) + " / " + str(player_ref.max_mana))
	for i in range(player_ref.BASE_STARTING_HAND_SIZE):
		draw_card()

func _process(delta: float) -> void:
	$ManaAmount.text = str(str(player_ref.mana) + " / " + str(player_ref.max_mana))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func draw_card():
	var card_drawn_name = player_deck[0]
	player_deck.erase(card_drawn_name)
	
	if player_deck.size() == 0:
		$Area2D/CollisionShape2D.disabled = true
		$Sprite2D.visible = false
		$CardAmount.visible = false
	
	var card_ref = card_database_reference.CARDS_LIBRARY[card_database_reference.CARDS_LIBRARY.bsearch_custom(card_drawn_name,get_card_by_name,true)-1] 
	
	$CardAmount.text = str(player_deck.size())
	var card_scene = preload(CARD_SCENE_PATH)
	var new_card = card_scene.instantiate()
	var card_image_path = str(card_ref.Assets[card_ref.Assets.bsearch_custom(card_database_reference.ASSETS.ART,get_asset_type,true)-1][1]) 
	# str("res://Assets/" + card_drawn_name + "Card.png")
	new_card.get_node("CardImage").texture = load(card_image_path)
	new_card.get_node("Attack").text = str(card_ref.Stats[0])
	new_card.get_node("Health").text = str(card_ref.Stats[1])
	$"../../CardManager".add_child(new_card)
	new_card.name = "Card"
	new_card.cost = card_ref.Cost
	new_card.card_name = card_ref.Name
	new_card.get_node("CardName").text = str(card_ref.Name)
	new_card.triggers = card_ref.Triggers
	$"../PlayerHand".add_card_to_hand(new_card, CARD_DRAW_SPEED)
	new_card.get_node("AnimationPlayer").play("card_flip")

func get_card_by_name(a, b):
	if a.Name == b:
		return true
	return false

func get_asset_type(a, b):
	if a[0] == b:
		return true
	return false
