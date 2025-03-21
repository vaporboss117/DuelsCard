extends Node

signal event_trigger(event_name:String,event_info:Array)

var event_trigger_cases:Dictionary={
	"String":[
		(func(event_info):
			# run check and event fuctions 
			
			)
	]
}

var event_lambda_list:Dictionary={}

func _ready():
	initialize_event_trigger_cases()

func initialize_event_trigger_cases()->void:
	for event in event_trigger_cases:
		var event_lambda = func(event_name,event_info):
			if event_name == event:
				for function_lambda in event_trigger_cases[event]:
					function_lambda.call(event_info)
		event_lambda_list[event] = event_lambda
		event_trigger.connect(event_lambda)

func add_event (event_name_base:String,event_lambda=null)->void:
	# if there is no valid event for it yet, creat and initalize it
	if not event_trigger_cases.has(event_name_base):
		var event_lambda_caller = func(event_name,event_info):
			if event_name == event_name_base:
				for function_lambda in event_trigger_cases[event_name_base]:
					function_lambda.call(event_info)
		event_lambda_list[event_name_base]=event_lambda_caller
		event_trigger_cases[event_name_base] = []
	# Add it to the case list
	event_trigger_cases[event_name_base].push_back(event_lambda)

func remove_event(event_name_base:String="all_instances",event_lambda=null)->void:
	if not event_trigger_cases.has(event_name_base):return
	event_trigger_cases[event_name_base].erase(event_lambda)
	#If empty trigger, clear then remove from call list
	if event_trigger_cases[event_name_base].size() == 0:
		event_trigger_cases.erase(event_name_base)
		event_trigger.disconnect(event_lambda_list[event_name_base])
		event_lambda_list.erase(event_name_base)
