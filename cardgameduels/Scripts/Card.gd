extends Node2D

signal hovered
signal hovered_off

var hand_position
var card_slot
var card_type
var cost
var triggers
var card_name


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# All cards must be a child of CardManager or this will error
	get_parent().connect_card_signals(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_mouse_entered() -> void:
	hovered.emit() # emit_signal("hovered",self)


func _on_area_2d_mouse_exited() -> void:
	hovered_off.emit()
