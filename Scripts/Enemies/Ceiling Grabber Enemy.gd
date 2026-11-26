extends GroundEnemy

#This guy grabs pikmin and brings them to its main body, where it destroys them
#The base movement is unchanged from groundenemy, so look there for that

#The grabber (the magnet) is let out, equal to the cooldown. It can't grab anything until fully extended
#Once it grabs something, its pulled back in. This takes a while, giving the player time to save the guy
#It slowly kills the victim, and once they have to HP, it resumes operation

#The grabber bobs up/down, left/right using a sin timer, becoming more drastic based on the extension of the grabber



var grabber : Node2D

var bobT : Vector2
@export var grabberBobSpeed : Vector2 = Vector2(1, 1.2)
@export var grabberBobAmplitude : Vector2 = Vector2(10, 8)

var reelInMultiplier : float = 2

var victim : Entity
@export var trapAttackTimerMax : float = 0.5
var trapAttackTimerCur : float

@export var trapDamage : int = 1

var frameSprite : Sprite2D


var chainSprite : Sprite2D
var chainConnection : Node2D






func _ready() -> void:
	super._ready()
	frameSprite = $"Sprites/Frame"
	
	grabber = $Sprites/Magnet
	searchLight.rotation = PI/2
	
	chainSprite = $Sprites/Chain
	chainConnection = $"Sprites/Magnet/Chain Connection"
	
	

#SCANNING_________________________________________________________-

func _scan(delta : float) :
	super._scan(delta)

	if _hasValidTarget() :
		_attack(searchRay.get_collider())
		return
	
	var grabT = 1 - (attackCooldownCur/attackCooldownMax)
	_bobGrabber(delta, grabT)
	
	
	
	
#ATTACKING__________________________________________________
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
	
	_bobGrabber(delta, grabT)
	

func _attack(node : Node2D):
	super._attack(node)
	victim = node
	freeze = true
	trapAttackTimerCur = trapAttackTimerMax
	treadsAnim.speed_scale = 0
	
func _endAttack():
	super._endAttack()
	treadsAnim.speed_scale = treadsSpeed * direction
	
func _on_contact_hitbox_body_entered(body: Node2D) -> void:
	if body == victim :
		return
	
	super._on_contact_hitbox_body_entered(body)
		
	

#ANIMATING______________________________________________________________________________
func _bobGrabber(delta : float, grabT : float) :
	bobT += delta * grabberBobSpeed
	var x : float = (searchRayBaseDir.x + cos(bobT.x) * grabberBobAmplitude.x) * grabT
	var y : float = (searchRayBaseDir.y + sin(bobT.y) * grabberBobAmplitude.y) * grabT
	var pos : Vector2 = Vector2(x, y)
	
	searchRay.target_position = pos
	grabber.position = pos
	searchLight.scale.x = searchRay.target_position.length()/16
	searchLight.scale.y = grabT
	
	if victim != null :
		victim.global_position = grabber.global_position
	
	
	chainSprite.global_position = (frameSprite.global_position + grabber.global_position)/2
	chainSprite.skew = (frameSprite.global_position.x - grabber.global_position.x)/45
	
	chainSprite.material.set_shader_parameter("Frame_UV", frameSprite.get_screen_transform().origin / Vector2(get_window().size))
	chainSprite.material.set_shader_parameter("Grabber_UV", (chainConnection.get_screen_transform().origin) / Vector2(get_window().size))
