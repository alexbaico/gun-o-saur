extends Node2D

var launched = false
var velocity = Vector2(0, 0)

var mass

func _process(delta):
	
	if launched:
		velocity += Global.gravity_vector*Global.gravity*mass*delta
		get_parent().position += velocity*delta
		#rotation = velocity.angle()

func launch(initial_velocity : Vector2):
	launched = true
	#velocity = initial_velocity * speed
	velocity = initial_velocity
