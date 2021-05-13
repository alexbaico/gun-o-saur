extends KinematicBody2D

export (PackedScene) var Skillshot1
export (PackedScene) var Skillshot2
export (PackedScene) var Skillshot3

onready var SkillshotSpawn = $AngleLineToBeSprite/SkillshotSpawn
onready var AngleLine = $AngleLineToBeSprite

var selected_skillshot_index = 0
onready var skills = [Skillshot1, Skillshot2, Skillshot3]

var speed = 100
var gravity = 9800

var life = 200

enum {IDLE, MOVING, HURT, DEAD, FIRING} #state FALLING?

var state
var velocity = Vector2.ZERO

#sera el power por segundo que se mantenga apretado
var fire_power = 300
#var fire_angle_vector = Vector2.ONE.normalized()
const max_fire_power = 2000
#var min_fire_power = 100 #Implementar?
var fire_power_acum = 0

var angle = - PI/4 #in radians (uglyyyy)
const angle_multiplier = 0.8 #multiplicador para que se mueva mas rapido el indicador del angulo
var angle_max = -PI/2
var angle_min = 0

var turn = false

func get_input(delta):

	if state == HURT:
		return 
	
	if state == FIRING:
		accumulate_fire_power(delta)
	
	if state != FIRING && Input.is_action_pressed('ui_fire'):
		state = FIRING
		#save_fire_angle()

	var right = Input.is_action_pressed('ui_right')
	var left = Input.is_action_pressed('ui_left')
	if is_on_floor():
		if right:
			velocity.x += speed
			angle_max = -PI/2
			angle_min = 0
			if  -PI <= angle && angle <= -PI/2:
				angle = - (PI + angle)
				AngleLine.rotation = angle

		if left:
			velocity.x -= speed
			angle_max = -PI
			angle_min = -PI/2
			if  -PI/2 <= angle && angle <= 0:
				angle = -PI - angle
				AngleLine.rotation = angle
	
	if state == IDLE and velocity.x != 0:
		state = MOVING
	if state == MOVING and velocity.x == 0:
		state = IDLE
	
func get_animation():
	match state:
		IDLE:
			pass #animationTree.travel()
		MOVING:
			pass #animationTree.travel()
		HURT:
			pass #animationTree.travel()
		DEAD:
			pass #animationTree.travel()

func get_angle_from_keyboard(delta):
	var angle_input = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if angle_input != 0:
		angle = clamp(angle + (angle_input if angle > -PI/2 else angle_input * -1)  * delta * angle_multiplier, angle_max, angle_min) #pasar min y max a variables?  
		AngleLine.rotation = angle

func get_angle_from_mouse(delta):
	angle = get_angle_to(get_global_mouse_position())
	AngleLine.rotation = angle

func _physics_process(delta):
	velocity.x = 0
	if turn:
		get_input(delta)
		#Tal vez el angula pueda depender del modo de juego? mas o menos caotico
		#get_angle_from_keyboard(delta)
		get_angle_from_mouse(delta)
		select_skillshot()
	velocity.y = gravity * delta
	velocity = move_and_slide(velocity, Vector2(0,-1))

func select_skillshot():
	if Input.is_action_just_pressed("skill0"):
		selected_skillshot_index = 0
	if Input.is_action_just_pressed("skill1"):
		selected_skillshot_index = 1
	if Input.is_action_just_pressed("skill2"):
		selected_skillshot_index = 2

func fire():
	var skillshot = skills[selected_skillshot_index].instance()
	skillshot.position = SkillshotSpawn.global_position
	get_parent().add_child(skillshot)
	skillshot.get_skillshot_behaviour().launch(Vector2(cos(angle), sin(angle)) * fire_power_acum)
	fire_power_acum = 0

func accumulate_fire_power(delta):
	if !Input.is_action_pressed("ui_fire"):
		fire()
		state = IDLE 
	else:
		fire_power_acum = clamp(fire_power_acum + fire_power * delta, 0, max_fire_power)

func receive_damage(damage_amount):
	life -= damage_amount
	if life <= 0:
		state = DEAD

#funcion para guardar el angulo si no se pudiese cambiar al empezar a disparar
#func save_fire_angle():
#	var angle = get_angle_to(get_global_mouse_position())
#	fire_angle_vector = Vector2(cos(angle), sin(angle))
