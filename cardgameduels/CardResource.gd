@tool
class_name  card_resource
extends Resource

@export var script_source:Script:
	set(v):
		script_source = v
		notify_property_list_changed()
	get:return script_source
var card_functions:PackedStringArray = PackedStringArray()
var card_function_trigger_case:PackedStringArray = PackedStringArray()
var card_count:int=0

func _get_property_list():
	
	#Placeholder
	var trigger_event_list = ["onCast","onSummon","onStrike","onStrikePlayer","onStrikeCreature","onDeath","onTurnStart","onTurnEnd","onAttack","onGrow","onAttackSelf"]
	
	var script_function_list:Array=[]
	if script_source == null:return []
	script_source.get_script_method_list().map(func(a):script_function_list.push_back(a.name))
	
	var properties = []
	
	properties.append({
		"name": "CardEvent_count",
		"type": TYPE_INT,
		"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_ARRAY,
		"hint": PROPERTY_HINT_NONE,
		"hint_string": "",
		"class_name": "CardEvent,CardEvent_"
	})
	
	for i in card_count:
		properties.append({
			"name": "CardEvent_%s/trigger_method"%str(i),
			"type": TYPE_STRING,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": ",".join(script_function_list)
		})
		properties.append({
			"name": "CardEvent_%s/trigger_event"%str(i),
			"type": TYPE_STRING,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": ",".join(trigger_event_list)
		})
	return properties

func _get(property):
	if property.begins_with("CardEvent"):
		var event_index = int(property.split('_')[1].split("/")[0])
		if property.ends_with("trigger_method"):
			return card_functions[event_index]
		if property.ends_with("trigger_event"):
			return card_function_trigger_case[event_index]
		if property == "CardEvent_count":return card_count

func _set(property, value):
	if property.begins_with("CardEvent"):
		var event_index = int(property.split('_')[1].split("/")[0])
		if property.ends_with("trigger_method"):
			card_functions[event_index] = value
		if property.ends_with("trigger_event"):
			card_function_trigger_case[event_index] = value
		if property == "CardEvent_count":
			card_count = value
			card_functions.resize(card_count)
			card_function_trigger_case.resize(card_count)
			notify_property_list_changed()
		return true
	return false
