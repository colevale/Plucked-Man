class_name GroundEnemy
extends Enemy

#TODO : Make the vertical rays use groups

var horizRay : RayCast2D
var leftVertRay : RayCast2D
var rightVertRay : RayCast2D

@export var walkSpeed : float = 10
@export var direction : float = 1

var horizRayBaseDir : Vector2
var searchRayBaseDir : Vector2

@export var customSearchlightBehavior : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	horizRay = $"Rays/Horizontal Ray"
	horizRayBaseDir = horizRay.target_position
	
	leftVertRay = $"Rays/Left Vertical Ray"
	rightVertRay = $"Rays/Right Vertical Ray"
	
	searchRayBaseDir = searchRay.target_position
	
	if direction < 0 :
		horizRay.target_position = Vector2(horizRayBaseDir.x*-1, horizRayBaseDir.y)
		searchRay.target_position = Vector2(searchRayBaseDir.x*-1, searchRayBaseDir.y)
	
	searchLight.scale.x = searchRay.target_position.length()/16
	
	#apply_force(Vector2.RIGHT * delta * walkSpeed *direction)
func _move(delta : float) :
	super._move(delta)
	#apply_force(Vector2.RIGHT * delta * walkSpeed * direction)
	global_position.x += delta * walkSpeed * direction
	if direction > 0 :
		if !rightVertRay.is_colliding() || horizRay.is_colliding(): 
			direction = -1
			horizRay.target_position = Vector2(horizRayBaseDir.x*-1, horizRayBaseDir.y)
			searchRay.target_position = Vector2(searchRayBaseDir.x*-1, searchRayBaseDir.y)
	elif direction < 0 :
		if !leftVertRay.is_colliding()  || horizRay.is_colliding(): 
			direction = 1
			horizRay.target_position = horizRayBaseDir
			searchRay.target_position = searchRayBaseDir
	
	if !customSearchlightBehavior :
		searchLight.flip_h = direction < 0
			


		
		
