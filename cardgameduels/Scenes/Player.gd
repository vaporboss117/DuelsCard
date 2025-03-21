extends Node2D

const BASE_STARTING_HAND_SIZE = 3
const BASE_STARTING_MANA_MAX = 10

var deck_ref

var max_mana_turn_triggers = 0
var max_mana = 0
var max_mana_current = max_mana
var mana = max_mana_current

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	deck_ref = $Deck

func turn_start():
	if max_mana_turn_triggers < BASE_STARTING_MANA_MAX:
		max_mana_turn_triggers += 1
		max_mana += 1 # _grow(1,self)
	mana_refresh()
	if deck_ref.player_deck.size() > 0:
		deck_ref.draw_card()

func mana_refresh ():
	max_mana_current = max_mana
	mana = max_mana_current
