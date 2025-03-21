extends Node

var function_scripts:Dictionary={}

func add_fuction_script(func_script:Script,custom_name:String="NO_CUSTOM")->void:
	var ref = RefCounted.new()
	ref.set_script(func_script)
	if custom_name!="NO_CUSTOM":
		function_scripts[custom_name] = ref
	else:
		var func_name = func_script.resource_path.split("/")[-1].trim_suffix(".gd")
		function_scripts[func_name] = ref

func get_func_script(script_name:String)->RefCounted: 
	if script_name.ends_with(".gd"):
		script_name = script_name.split("/")[-1].trim_suffix(".gd")
	return function_scripts.get(script_name,null)
