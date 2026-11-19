class_name Enemy
extends Entity


var isAttacking : bool = false
@export var attackSpeed : float = 20
@export var attackCooldownMax : float = 5
var attackCooldownCur : float

var searchLight : Sprite2D
var searchRay : RayCast2D
@export var canAttackColor : Color = Color(0, 1, 0, 1)
@export var cantAttackColor : Color = Color(1, 0, 0, 0.5)


@export var contactDamage : float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	attackCooldownCur = attackCooldownMax
	searchLight = $Searchlight
	searchRay = $"Rays/Search Ray"


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
		return
		
	
	#If no attack, move normal
	_move(delta)
	
	#if no attack, scan for possible targets
	_scan(delta)
	



func _scan(_delta : float) :
	pass

func _attack(node : Node2D) :
	isAttacking = true
	attackCooldownCur = attackCooldownMax

func _endAttack() :
	isAttacking = false
	attackCooldownCur = attackCooldownMax

func _move(_delta : float) :
	pass
	
func _attackMove(_delta : float) :
	pass
	
func _onDeath() :
	super._onDeath()
	
func _hasValidTarget() -> bool :
	return !isAttacking && attackCooldownCur <= 0 && searchRay.is_colliding() && searchRay.get_collider().is_in_group("Player")

func _on_contact_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") :
		body._updateHP(contactDamage)
