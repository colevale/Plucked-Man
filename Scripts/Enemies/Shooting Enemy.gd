extends GroundEnemy


var searchAngle : float
var searchSpeed : float = 1
var searchDist : float
var searchIndicator : Node2D

@export var seekDir : float = 1
@export var minAngleRad : float = 0
@export var maxAngleRad : float = PI

@export var angleOffsetRad : float = 0

@export var projectileScene : String


func _ready() :
	super._ready()
	searchDist = searchRay.target_position.length()
	searchIndicator = $"Search Indicator"

func _scan(delta : float) :
	super._scan(delta)
	searchAngle += delta * searchSpeed * seekDir
	if searchAngle > maxAngleRad :
		seekDir = -1
	if searchAngle < minAngleRad :
		seekDir = 1
	
	var searchDir = Vector2.from_angle(searchAngle+angleOffsetRad)*searchDist
	
	searchIndicator.position = searchDir	
	searchRay.target_position = searchIndicator.position
	
	
	if attackCooldownCur <= 0 && searchRay.is_colliding() && searchRay.get_collider().get("name") == "Player" :
		_attack(searchRay.get_collider())
		
		
func _attack(node : Node2D) :
	super._attack(node)
	isAttacking = false
	
	
	var proj : Projectile = load(projectileScene).instantiate()
	get_tree().root.add_child(proj)
	proj._shoot(node.global_position-global_position, global_position)
	
	#var scene = load("res://scenes/MyScene.tscn")
	#var scene_instance = scene.instance()
	#scene_instance.set_name("scene")
	#add_child(scene_instance)
	#print("SHOOT!!!!!")
