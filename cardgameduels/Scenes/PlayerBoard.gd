extends Node2D

const CARD_WIDTH = 160
const HAND_Y_POSITION = 755
const DEFAULT_CARD_MOVE_SPEED = 0.1

var player_board = []
var center_screen_x

func _ready() -> void:
	center_screen_x = get_viewport().size.x / 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_card_to_board(card, speed):
	if card not in player_board:
		player_board.insert(0, card)
		# card.card_in_slot = true
		update_board_positions(speed)
	else:
		animate_card_to_position(card, card.hand_position, DEFAULT_CARD_MOVE_SPEED)

func update_board_positions(speed):
	for i in range(player_board.size()):
		# Get new card position based on index
		var new_position = Vector2(calculate_card_position(i), HAND_Y_POSITION)
		var card = player_board[i]
		card.hand_position = new_position
		animate_card_to_position(card, new_position, speed)

func animate_card_to_position(card, new_position, speed):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, speed)

func calculate_card_position(index):
	var x_offset = (player_board.size() -1) * CARD_WIDTH
	var x_position = center_screen_x + index * CARD_WIDTH - x_offset / 2
	return x_position
