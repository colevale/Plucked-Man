extends Enemy

#The flying enemy flys around and charges at the player on sight

#It has 4 rays that detect when an object is near, and pushes away from it
	#When a ray sees smt, also animates its thruster
	#This is done on the "Fline Thruster Script tho

#the searchlight moves in a circle, and if the searchray spots the player
	#it linearly shoots itself at their current position

var positionRays : Array[RayCast2D]
@export var idleSpeed : float = 100

#
var searchAngle : float = 0
var searchSpeed : float = 1
var searchDist : float
var curDir : float = 1


var thrusterHolder : Node2D
@export var thrusterRotateSpeed : float = -2

@export var velocityDecayMult : float = 10


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	super._ready()
	
	for i in $"Rays/Move Rays".get_children() :
		positionRays.append(i)
	positionRays.append(searchRay)
	searchDist = searchRay.target_position.length()
	searchLight.scale.x = searchDist/16
	
	thrusterHolder = $"Rays/Move Rays"

#MOVEMENT__________________________________________________
func _move(delta : float) :
	super._move(delta)
	var dir : Vector2 = Vector2.ZERO
	for i in positionRays :
		if i.is_colliding() :
			var vect : Vector2 = global_position - i.get_collision_point()
			dir += vect.normalized() * 1/(vect.length()*vect.length())
	
	velocity += dir.normalized() * idleSpeed
	move_and_slide()
	velocity *= 1-(delta*velocityDecayMult)
	#apply_force()
	


#SCANNING__________________________________________________
func _scan(delta : float) :
	super._scan(delta)
	searchAngle += delta * searchSpeed * curDir
	if searchAngle > PI :
		curDir = -1
	elif searchAngle < -PI :
		curDir = 1
	
	var searchDir = Vector2.from_angle(searchAngle+PI/2)*searchDist
	#if searchAngle > 0 :
	#	searchDir.y *= -1
	
	
	
	searchRay.target_position = searchDir
	searchLight.rotation = get_angle_to(global_position + searchDir)
	
	if _hasValidTarget() :
		_attack(searchRay.get_collider())
	#print("Flying guy, " + str(searchRay.get_collider()))

#ATTACKING__________________________________________________________
func _attackMove(delta : float):
	super._attackMove(delta)
	move_and_slide()
	if searchRay.is_colliding() :
		_endAttack()
		
		
func _attack(node : Node2D):
	super._attack(node)
	searchRay.target_position /= 5
	velocity = searchRay.target_position.normalized() * attackSpeed
	

func _on_contact_hitbox_body_entered(body: Node2D) -> void:
	super._on_contact_hitbox_body_entered(body)
	_endAttack()
	
	

#ANIMATING_________________________________________________________________________
#FOR MORE ON THIS GUYS ANIMATION, LOOK AT FLINE THRUSTER
func _animateParts(delta : float):
	#eyeStart and eyeEnd should be length equal to side/neutral pos
	#but facing the angle its searching at
	eyesCurStart = Vector2.from_angle(searchAngle+PI/2)*eyesCurStart.length()
	eyesCurEnd = Vector2.from_angle(searchAngle+PI/2)*eyesCurEnd.length()
	super._animateParts(delta)
	
	thrusterHolder.rotate(delta * thrusterRotateSpeed)
