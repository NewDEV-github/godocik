extends Camera2D

onready var fighters_node = get_parent().get_node("Fighters")
var half_positions
var fighter1 
var fighter2 

func _physics_process(delta):
	camera_normal()

func _ready():
	pass 

func camera_normal():
	if Global.fight:
		var half = abs(Global.fighters[0].position.x-Global.fighters[1].position.x)/2.0
		var z = clamp(abs(Global.fighters[0].position.x-Global.fighters[1].position.x)/1400.0,1,3)
		zoom=Vector2(z,z)
		position=Vector2(min(Global.fighters[0].position.x,Global.fighters[1].position.x)+half,500)
	

	
