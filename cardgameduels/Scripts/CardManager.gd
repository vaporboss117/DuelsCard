extends Node2D

const COLLISION_MASK_CARD = 1
const COLLISION_MASK_SLOT = 2
const DEFAULT_CARD_MOVE_SPEED = 0.1
const DEFAULT_CARD_SCALE = 0.8
const CARD_SCALE_BIGGER = 0.85
const CARD_SCALE_SMALLER = 0.6

var screen_size
var card_being_draged
var is_hovering_on_card
var player_hand_reference
var player_board_ref
var player_ref
var database_ref

func _ready() -> void:
	screen_size = get_viewport_rect().size
	player_hand_reference = $"../Player/PlayerHand"
	$"../InputManger".connect("left_mouse_button_released", on_left_click_released)
	player_ref = $"../Player"
	player_board_ref = $"../Player/PlayerBoard"
	database_ref = preload("res://Scripts/CardDatabase.gd")

func _process(delta: float) -> void:
	if card_being_draged:
		var mouse_pos = get_global_mouse_position()
		card_being_draged.position = Vector2(clamp(mouse_pos.x, 0,screen_size.x),
			clamp(mouse_pos.y, 0,screen_size.y))

func start_drag(card):
	card_being_draged = card
	card.scale = Vector2(DEFAULT_CARD_SCALE,DEFAULT_CARD_SCALE)

func finish_drag():
	card_being_draged.scale = Vector2(CARD_SCALE_BIGGER,CARD_SCALE_BIGGER)
	var card_slot_found = raycast_check_for_board()
	if card_slot_found and card_being_draged.cost <= player_ref.mana:
		# Card dropped in card slot
		player_ref.mana -= card_being_draged.cost
		card_being_draged.scale = Vector2(CARD_SCALE_SMALLER,CARD_SCALE_SMALLER)
		card_being_draged.z_index = -1
		card_being_draged.card_slot = card_slot_found
		check_trigger(card_being_draged,database_ref.TRIGGERS.CAST)
		player_hand_reference.remove_card_from_hand(card_being_draged)
		card_being_draged.position = card_slot_found.position
		card_being_draged.get_node("Area2D/CollisionShape2D").disabled = true
		# card_slot_found.card_in_slot = true
		player_board_ref.add_card_to_board(card_being_draged,DEFAULT_CARD_MOVE_SPEED)
	else:
		player_hand_reference.add_card_to_hand(card_being_draged, DEFAULT_CARD_MOVE_SPEED)
	card_being_draged = null

func connect_card_signals(card):
	card.connect("hovered", on_hovered_over_card)
	card.connect("hovered_off", on_hovered_off_card)

func on_left_click_released():
	if card_being_draged:
		finish_drag()

func on_hovered_over_card(card):
	if !is_hovering_on_card:
		is_hovering_on_card = true
		highlight_card(card,true)

func on_hovered_off_card(card):
	# Check if card is NOT a card slot AND NOT being dragged
	if !card.card_slot && !card_being_draged:
		# if not dragging
		highlight_card(card,false)
		# Check if hovered off card straight to another card
		var new_card_hovered = raycast_check_for_card()
		if new_card_hovered:
			highlight_card(new_card_hovered, true)
		else:
			is_hovering_on_card = false

func highlight_card(card, hovered):
	if hovered:
		card.scale = Vector2(CARD_SCALE_BIGGER,CARD_SCALE_BIGGER)
		card.z_index = 2
	else:
		card.scale = Vector2(DEFAULT_CARD_SCALE,DEFAULT_CARD_SCALE)
		card.z_index = 1

func raycast_check_for_card_slot():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_SLOT
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null

func raycast_check_for_board():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_SLOT
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null

func raycast_check_for_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return get_card_with_highest_z_index(result)
	return null

func get_card_with_highest_z_index(cards):
	var highest_z_card = cards[0].collider.get_parent()
	var highest_z_index = highest_z_card.z_index
	
	for i in range(1, cards.size()):
		var current_card = cards[i].collider.get_parent()
		if current_card.z_index > highest_z_index:
			highest_z_card = current_card
			highest_z_index = current_card.z_index
	return highest_z_card

func check_trigger(card,triggerType):
	for i in range(1, card.triggers.size()):
		if card.triggers[i][0] == triggerType:
			card.triggers[i][1].call()
