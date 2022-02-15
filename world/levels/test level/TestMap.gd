extends Node2D

var max_fighter = 3

func _ready():
	load_fighters_position()
	
func load_fighters_position(): #share positions for fighters
	var fighter_node = "Fighter" 
	for i in Global.fighters_checked_number:
		var fighter_position = "Fighter" + str(i+1)
		print(fighter_position)
		Global.fighters_positions.append(get_node(fighter_position).position)
		print(Global.fighters_positions)


