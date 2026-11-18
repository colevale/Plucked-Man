class_name Enemy
extends RigidBody2D


var isAttacking : bool = false
@export var attackSpeed : float = 20
@export var attackCooldownMax : float = 5
var attackCooldownCur : float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	attackCooldownCur = attackCooldownMax


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	attackCooldownCur -= delta
	if attackCooldownCur < 0 :
		attackCooldownCur = 0
	
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
