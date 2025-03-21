@tool
extends RefCounted

func _pillage(count):
	# Take card from the bottom of the other players deck
	print("Pillage %s"%[str(count)]) 

func _grow(count,player_ref):
	# Gain a mana slot
	for i in range(player_ref):
		player_ref[i].max_mana += count
	# on mana gain triggers
	for i in range(count):
		#trigger each mana gain thing
		print("Mana gaing triggered %s"%[str(i)])
	print("Grow %s"%[str(count)])
