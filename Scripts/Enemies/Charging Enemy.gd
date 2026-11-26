extends GroundEnemy

#Very basic enemy, moves forward, and it spots something ahead of it, it increases speed

#A notable quick is that this guy isnt symmetrical, which breaks some animations
#Therefore, this guys eyes dont move positions cause I was lazy

#The attacking movement literally just calls the movement with a multiplier
	#The attacking mode ends when reaching the edge, not on collision with a player


@export var jumpHeight : float = 5

var landCooldown : float = 0.5
var spritesHolder : Node2D

func _ready() -> void:
	super._ready()
	spritesHolder = $Sprites


#MOVEMENT_____________________________________________________________________
func _move(delta : float):
	#apply_force(Vector2.RIGHT * delta * walkSpeed * direction)
	global_position.x += delta * walkSpeed * direction
	if direction > 0 :
		if !rightVertRay.is_colliding() || (horizRay.is_colliding()&&!horizRay.get_collider().is_in_group("Player")): 
			direction = -1
			horizRay.target_position = Vector2(horizRayBaseDir.x*-1, horizRayBaseDir.y)
			searchRay.target_position = Vector2(searchRayBaseDir.x*-1, searchRayBaseDir.y)
	elif direction < 0 :
		if !leftVertRay.is_colliding()  || (horizRay.is_colliding()&&!horizRay.get_collider().is_in_group("Player")): 
			direction = 1
			horizRay.target_position = horizRayBaseDir
			searchRay.target_position = searchRayBaseDir
	
	if !customSearchlightBehavior :
		searchLight.flip_h = direction < 0
		
		

#SCANNING_______________________________________________________________________
func _scan(_delta : float):
	if !isAttacking && attackCooldownCur <= 0 && searchRay.is_colliding() && searchRay.get_collider().get("name") == "Player" :
		_attack(searchRay.get_collider())
		attackCooldownCur = landCooldown
		
		
#ATTACKING____________________________________________________________________________
func _attackMove(delta : float):
	_move(delta * attackSpeed)
	#attackCooldownCur -= delta
	
	if !leftVertRay.is_colliding() || !rightVertRay.is_colliding() || (horizRay.is_colliding() && !horizRay.get_collider().is_in_group("Player")):
		_endAttack()

func _attack(node : Node2D):
	super._attack(node)
	treadsAnim.speed_scale = treadsSpeed * attackSpeed * direction
	#linear_velocity = Vector2.ZERO
	#apply_force(Vector2(attackSpeed*direction, -jumpHeight))

func _endAttack():
	super._endAttack()
	treadsAnim.speed_scale = treadsSpeed * direction


#Animating____________________________________________________________________
func _animateParts(delta : float):
	#super._animateParts(delta)
	if direction < 0 :
		spritesHolder.scale.x = -1
	else :
		spritesHolder.scale.x = 1
		
	if eyesHurtTimer > 0 :
		eyesHurtTimer -= delta
		if eyesHurtTimer < 0 && isAttacking:
			eyeSprite.frame = EyesFrames.ATTACK + eyeSprite.hframes*eyeRow
		if eyesHurtTimer < 0 :
			eyeSprite.frame = EyesFrames.IDLE + eyeSprite.hframes*eyeRow
