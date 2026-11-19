extends GroundEnemy

var grabber : Node2D

var bobT : float
var grabberBobSpeed : float = 1
var grabberBobAmplitude : float = 20

var reelInMultiplier : float = 2

var victim : Entity
@export var trapAttackTimerMax : float = 0.5
var trapAttackTimerCur : float

@export var trapDamage : int = 1


func _ready() -> void:
	super._ready()
	grabber = $Grabber
	searchLight.rotation = PI/2
	


func _move(delta : float) :
	super._move(delta)

func _scan(delta : float) :
	super._scan(delta)

	if _hasValidTarget() :
		_attack(searchRay.get_collider())
		return
	
	var grabT = 1 - (attackCooldownCur/attackCooldownMax)
	
	bobT += delta * grabberBobSpeed
	var y : float = (searchRayBaseDir.y + sin(bobT) * grabberBobAmplitude) * grabT
	searchRay.target_position.y = y
	grabber.position.y = y
	searchLight.scale.x = searchRay.target_position.length()/16
	searchLight.scale.y = grabT
	
	
func _attackMove(delta : float):
	super._attackMove(delta)
	
	attackCooldownCur += delta / reelInMultiplier
	var grabT : float = (attackCooldownCur/attackCooldownMax)	
	
	if grabT < 0.1 :
		trapAttackTimerCur -= delta
		if trapAttackTimerCur < 0 :
			trapAttackTimerCur = trapAttackTimerMax
			if victim != null :
				victim._updateHP(trapDamage)
			else :
				_endAttack()
		return
			
			
		#_endAttack()
		#return
	
	
	bobT += delta * grabberBobSpeed
	var y : float = (searchRayBaseDir.y + sin(bobT) * grabberBobAmplitude) * grabT
	searchRay.target_position.y = y
	grabber.position.y = y
	
	searchLight.scale.x = searchRay.target_position.length()/16
	searchLight.scale.y = grabT
	
	victim.global_position = grabber.global_position
	

func _attack(node : Node2D):
	super._attack(node)
	victim = node
	freeze = true
	trapAttackTimerCur = trapAttackTimerMax
	
func _on_contact_hitbox_body_entered(body: Node2D) -> void:
	if body == victim :
		return
	
	super._on_contact_hitbox_body_entered(body)
	
	
