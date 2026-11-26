class_name GroundEnemy
extends Enemy

#All the grounded enemies inherit this, including the tank, scrubber, and grabber
#Handles common movement and animations between them

#Movement is operated by 3 rays. End result if moving back and forth on a platform
	#Horizontal one swaps the movement direction if it hits a wall
	#Vertical ones detect the edge of a platform and swap direction at the ends
	
#Animation is just the treads. Makes sure its going the right direction


var horizRay : RayCast2D
var leftVertRay : RayCast2D
var rightVertRay : RayCast2D

@export var walkSpeed : float = 10
@export var direction : float = 1

var horizRayBaseDir : Vector2
var searchRayBaseDir : Vector2

@export var customSearchlightBehavior : bool = false

var treadsAnim : AnimationPlayer
var treadsSpeed : float

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

	treadsAnim = $"Sprites/Treads Anim"
	treadsSpeed = treadsAnim.speed_scale
	
	

func _process(delta: float) -> void:
	var prevDir = direction
	super._process(delta)
	if prevDir != direction :
		_newEyePosition()
	if !isAttacking :
		treadsAnim.speed_scale = treadsSpeed * direction

#MOVEMENT_____________________________________________________________________-
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
			
			
			
			
			
			



#Animation_________________________________________________________________
func _newEyePosition() :
	super._newEyePosition()
	if direction < 0 :
		eyesCurEnd.x *= -1
