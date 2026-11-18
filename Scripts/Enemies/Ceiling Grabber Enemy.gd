extends GroundEnemy

var grabber : Node2D

var bobT : float
var grabberBobSpeed : float = 1
var grabberBobAmplitude : float = 20

var reelInMultiplier : float = 2

var victim : Node2D


func _ready() -> void:
	super._ready()
	grabber = $Grabber
	


func _move(delta : float) :
	super._move(delta)

func _scan(delta : float) :
	super._scan(delta)
	if !isAttacking && attackCooldownCur <= 0 && searchRay.is_colliding() && searchRay.get_collider().get("name") == "Player" :
		_attack(searchRay.get_collider())
		return
	
	var grabT = 1 - (attackCooldownCur/attackCooldownMax)
	
	bobT += delta * grabberBobSpeed
	var y : float = (searchRayBaseDir.y + sin(bobT) * grabberBobAmplitude) * grabT
	searchRay.target_position.y = y
	grabber.position.y = y
	
	
func _attackMove(delta : float):
	super._attackMove(delta)
	
	attackCooldownCur += delta / reelInMultiplier
	var grabT : float = (attackCooldownCur/attackCooldownMax)	
	
	if grabT < 0.1 :
		_endAttack()
		return
	
	
	bobT += delta * grabberBobSpeed
	var y : float = (searchRayBaseDir.y + sin(bobT) * grabberBobAmplitude) * grabT
	searchRay.target_position.y = y
	grabber.position.y = y
	
	victim.global_position = grabber.global_position
	

func _attack(node : Node2D):
	super._attack(node)
	victim = node
	freeze = true
	
	
