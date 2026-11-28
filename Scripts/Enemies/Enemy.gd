class_name Enemy
extends Entity

#all enemies inherit this script
#beyond the HP stuff from entity, it features a bunch of functions for 
	#operating and animating the enemy
	
#Basic flowchart of how the enemy code works
	#Check cooldowns for attacking
		#If attacking, do attack movement
		#otherwise, normal movement
	#one function scans the area for potential targets
		#If one is found, swaps to attack mode
	#Final, animate the enemy
		#This includes eyes, feet/treads, etc



#Attacking vars
var isAttacking : bool = false
@export var attackSpeed : float = 20
@export var attackCooldownMax : float = 5
var attackCooldownCur : float


#Searchlight for scanning
var searchLight : Sprite2D
var searchRay : RayCast2D
@export var canAttackColor : Color = Color(0, 1, 0, 1) #color of the searchlight when attack cooldown is done
@export var cantAttackColor : Color = Color(1, 0, 0, 0.5)

@export var contactDamage : float = 1


#Eye stuff
var eyeSprite : Sprite2D
enum EyesFrames {
	IDLE = 0,
	ATTACK = 1, 
	HURT = 2,
	DEAD = 3
}
@export var eyeRow : int = 0 #Which row on the spritesheet to use
@export var eyesNeutralPos : Vector2
@export var eyesSidePos : Vector2
@export var eyesSpeed : float = 2 #transition speed between positions

var eyesT : float 
var eyesCurStart : Vector2
var eyesCurEnd : Vector2

@export var eyesHurtTimerMax : float = 0.5
var eyesHurtTimer : float





# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	attackCooldownCur = attackCooldownMax
	searchLight = $Searchlight
	searchRay = $"Rays/Search Ray"
	eyeSprite = $"Sprites/Frame/Eye Frame/Eyes"
	_newEyePosition()
	eyeSprite.frame = EyesFrames.IDLE + eyeSprite.hframes*eyeRow


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	attackCooldownCur -= delta
	if attackCooldownCur < 0 :
		attackCooldownCur = 0
		
		
	var t : float = attackCooldownCur/attackCooldownMax
	var color : Color = canAttackColor*(1-t) + cantAttackColor*t
	searchLight.material.set_shader_parameter("Color", color)
	
	#If attacking, do attack movement
	if isAttacking :
		_attackMove(delta)
		_animateParts(delta)
		return
		
	
	#If no attack, move normal
	_move(delta)
	
	#if no attack, scan for possible targets
	_scan(delta)
	
	
	_animateParts(delta)





#SCANNING______________________________________________________________________
func _scan(_delta : float) :
	pass
	

#MOVEMENT______________________________________________________________________
func _move(_delta : float) :
	pass



#ATTACKING____________________________________________________________________

func _attackMove(_delta : float) :
	pass

func _attack(_node : Node2D) :
	isAttacking = true
	attackCooldownCur = attackCooldownMax
	
	_newEyePosition()
	eyeSprite.frame = EyesFrames.ATTACK + eyeSprite.hframes*eyeRow

func _endAttack() :
	isAttacking = false
	attackCooldownCur = attackCooldownMax
	
	_newEyePosition()
	eyeSprite.frame = EyesFrames.IDLE + eyeSprite.hframes*eyeRow
	
func _hasValidTarget() -> bool :
	return !isAttacking && attackCooldownCur <= 0 && searchRay.is_colliding() && (searchRay.get_collider().is_in_group("Player") || searchRay.get_collider().is_in_group("Minion"))


func _on_contact_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") :
		body._updateHP(contactDamage)
		
	if body.is_in_group("Minion") :
		print("enemy working")
		body._updateHP(contactDamage)

#Taking damage____________________________________________________________________
func _updateHP(dir : int):
	super._updateHP(dir)
	if curHP > 0 :
		eyeSprite.frame = EyesFrames.HURT + eyeSprite.hframes*eyeRow
	else :
		eyeSprite.frame = EyesFrames.DEAD + eyeSprite.hframes*eyeRow
		
	eyesHurtTimer = eyesHurtTimerMax


#Animation____________________________________________________________________
func _animateParts(delta : float) :
	eyesT += delta * eyesSpeed
	if eyesT > 1 :
		eyesT = 1
	eyeSprite.position = (1-eyesT)*eyesCurStart + eyesT*eyesCurEnd


	if eyesHurtTimer > 0 :
		eyesHurtTimer -= delta
		if eyesHurtTimer < 0 && isAttacking:
			eyeSprite.frame = EyesFrames.ATTACK + eyeSprite.hframes*eyeRow
		if eyesHurtTimer < 0 :
			eyeSprite.frame = EyesFrames.IDLE + eyeSprite.hframes*eyeRow

func _newEyePosition() :
	eyesT = 0
	eyesCurStart = eyeSprite.position
	
	if isAttacking :
		eyesCurEnd = eyesNeutralPos
	else :
		eyesCurEnd = eyesSidePos
	
	
	#if direction < 0 :
	#	eyesCurEnd.x *= -1
