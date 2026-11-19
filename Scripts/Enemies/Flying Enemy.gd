extends Enemy

#TODO Get tags working for the check

var positionRays : Array[RayCast2D]
@export var idleSpeed : float = 100


var searchAngle : float = 0
var searchSpeed : float = 1
var searchDist : float

var curDir : float = 1



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	super._ready()
	
	for i in $"Rays".get_children() :
		positionRays.append(i)
	searchDist = searchRay.target_position.length()
	searchLight.scale.x = searchDist/16

func _move(delta : float) :
	super._move(delta)
	var dir : Vector2 = Vector2.ZERO
	for i in positionRays :
		if i.is_colliding() :
			var vect : Vector2 = global_position - i.get_collision_point()
			dir += vect.normalized() * 1/vect.length()
	
	apply_force(dir.normalized() * idleSpeed * delta)

func _attackMove(delta : float):
	super._attackMove(delta)
	global_position += delta * searchRay.target_position.normalized() * attackSpeed
	if searchRay.is_colliding() :
		_endAttack()

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
	
	if attackCooldownCur <= 0 && searchRay.is_colliding() && searchRay.get_collider().get("name") == "Player" :
		_attack(searchRay.get_collider())
		
		
func _attack(node : Node2D):
	super._attack(node)
	searchRay.target_position /= 5
	

func _on_contact_hitbox_body_entered(body: Node2D) -> void:
	super._on_contact_hitbox_body_entered(body)
