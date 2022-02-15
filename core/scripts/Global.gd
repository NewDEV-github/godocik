extends Node

#levels
var tests_map = preload("res://world/levels/test level/TestMap.tscn")

var checked_map = tests_map

var max_fighters = 4
var fighters_checked_number = 2

#fighters
var test_player1 = preload("res://content/player_test1/TestPlayer1.tscn")
var test_player2 = preload("res://content/player_test2/TestPlayer2.tscn")

var checked_fighters = [test_player1, test_player2]
var fighters_positions = []
var fighters = []


#fight
var fight = false
