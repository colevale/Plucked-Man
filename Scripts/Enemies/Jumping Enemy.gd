extends GroundEnemy


@export var jumpHeight : float = 5

var landCooldown : float = 0.5

func _scan(_delta : float):
	if !isAttacking && attackCooldownCur <= 0 && searchRay.is_colliding() && searchRay.get_collider().get("name") == "Player" :
		_attack(searchRay.get_collider())
		attackCooldownCur = landCooldown

func _attack(node : Node2D):
	super._attack(node)
	linear_velocity = Vector2.ZERO
	apply_force(Vector2(attackSpeed*direction, -jumpHeight))
	
func _attackMove(delta : float):
	attackCooldownCur -= delta
	
	if attackCooldownCur <= 0 && (leftVertRay.is_colliding() || rightVertRay.is_colliding()):
		_endAttack()
