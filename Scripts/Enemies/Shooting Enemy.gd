extends GroundEnemy

#Basic ground enemy, but shoots as its attack.
#For more on movement and animation, look to the GroundEnemy script

#The scanning moves the scanner in an arc, and once it sees the player it shoots
#Notably, this guy never enters attack more, just shoots and starts a cooldown

#The cannon is positioned by tweening its parts based on the angle.
	#Changing the angle the guy shoots at means you'd have to manually update the tween positions

var searchT : float
var searchSpeed : float = 1
var searchDist : float

@export var minAngleRad : float = 0
@export var maxAngleRad : float = PI/2

@export var angleOffsetRad : float = 0

@export var projectileScene : String

var cannonDefPos : Vector2 = Vector2(0, -10)
var cannonSidePos : Vector2 = Vector2(20, 0)

var cannon1 : Node2D
var cannon2 : Node2D
var cannon3 : Node2D
var cannon4 : Node2D
var cannon2T : float = 0.85
var cannon3T : float = 0.65
var cannon4T : float = 0.45

func _ready() :
	super._ready()
	cannon1 = $"Sprites/Frame/Cannon 1"
	cannon2 = $"Sprites/Frame/Cannon 2"
	cannon3 = $"Sprites/Frame/Cannon 3"
	cannon4 = $"Sprites/Frame/Cannon 4"
	searchDist = searchRay.target_position.length()


#SCANNING___________________________________________________________________________
func _scan(delta : float) :
	super._scan(delta)
	searchT += delta * searchSpeed
	var t : float = sin(searchT)
	var searchAngle : float = t*minAngleRad + (1-t)*maxAngleRad
	
	
	var searchDir = Vector2.from_angle(searchAngle+angleOffsetRad)*searchDist
	
	searchRay.target_position = searchDir
	searchLight.rotation = get_angle_to(global_position + searchDir)
	
	cannon1.position.x = (cannonDefPos.x*(1-t) + cannonSidePos.x*t)*-1
	cannon1.position.y = (cannonDefPos.y*(1-t*t) + cannonSidePos.y*t*t)
	cannon2.position = cannon1.position * cannon2T
	cannon3.position = cannon1.position * cannon3T
	cannon4.position = cannon1.position * cannon4T
	
	
	if _hasValidTarget() :
		_attack(searchRay.get_collider())



#ATTACKING______________________________________________________
func _attack(node : Node2D) :
	super._attack(node)
	eyesHurtTimer = eyesHurtTimerMax
	isAttacking = false
	
	
	var proj : Projectile = load(projectileScene).instantiate()
	get_tree().root.add_child(proj)
	proj._shoot(node.global_position-global_position, cannon1.global_position)
	
	
	
	#var scene = load("res://scenes/MyScene.tscn")
	#var scene_instance = scene.instance()
	#scene_instance.set_name("scene")
	#add_child(scene_instance)
	#print("SHOOT!!!!!")
