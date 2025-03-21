extends Node2D

signal left_mouse_button_clicked
signal left_mouse_button_released

const COLLISION_MASK_CARD = 1
const COLLISION_MASK_DECK = 4

var card_manager_reference
var deck_reference
var player_ref

func _ready() -> void:
	card_manager_reference = $"../CardManager"
	deck_reference = $"../Player/Deck"
	player_ref = $"../Player"

func _input(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			emit_signal("left_mouse_button_clicked")
			raycast_at_cursor()
		else:
			emit_signal("left_mouse_button_released")
	# if event is InputEventKey and 
	if Input.is_key_pressed(KEY_ENTER):
		player_ref.turn_start()
	else:
		event = null

func raycast_at_cursor():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	#parameters.collision_mask = COLLISION_MASK_CARD
	var result = space_state.intersect_point(parameters)
	print(result.size())
	if result.size() > 0:
		var result_collision_mask = result[0].collider.collision_mask
		print(result_collision_mask)
		if result_collision_mask == COLLISION_MASK_CARD:
			# Card clicked
			var card_found = result[0].collider.get_parent()
			if card_found:
				card_manager_reference.start_drag(card_found)
		elif result_collision_mask == COLLISION_MASK_DECK:
			# Deck clicked
			deck_reference.draw_card()
