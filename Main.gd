extends Node2D

export (PackedScene) var Mobile

func _ready():
	var mob1 = Mobile.instance()
	mob1.position = $spawn1.position
	add_child(mob1)
	var mob2 = Mobile.instance()
	mob2.position = $spawn2.position
	mob2.turn = true
	add_child(mob2)
	
