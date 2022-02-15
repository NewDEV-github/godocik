extends Node2D

var core_fighter = preload("res://world/core level/CoreFighter.tscn")
onready var level_node = get_node("Level")
onready var fighters_node = get_node("Fighters")
var fighters  = []

func _ready():
	load_map()
	load_fighters(Global.fighters_checked_number)
	Global.fight = true

func load_map():
	var level = Global.checked_map.instance()
	level_node.add_child(level)

func load_fighters(var i): # create Fighters/CoreFighter/fighter on good positions
	for i in Global.checked_fighters.size():
		var fighter_postion = Global.fighters_positions[i]
		var fighter_cores = core_fighter.instance()
		var player_i = Global.checked_fighters[i].instance()
		fighter_cores.position = fighter_postion
		fighter_cores.add_child(player_i)
		fighters_node.add_child(fighter_cores)

