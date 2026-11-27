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
@export var startDirection : float = 1

var horizRayBaseDir : Vector2
var searchRayBaseDir : Vector2

@export var customSearchlightBehavior : bool = false

var treadsAnim : AnimationPlayer
var treadsSpeed : float

@export var turnOnPlayer : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	horizRay = $"Rays/Horizontal Ray"
	horizRayBaseDir = horizRay.target_position
	
	leftVertRay = $"Rays/Left Vertical Ray"
	rightVertRay = $"Rays/Right Vertical Ray"
	
	searchRayBaseDir = searchRay.target_position
	
	if startDirection < 0 :
		horizRay.target_position = Vector2(horizRayBaseDir.x*-1, horizRayBaseDir.y)
		searchRay.target_position = Vector2(searchRayBaseDir.x*-1, searchRayBaseDir.y)
	searchLight.scale.x = searchRay.target_position.length()/16

	treadsAnim = $"Sprites/Treads Anim"
	treadsSpeed = treadsAnim.speed_scale
	
	velocity = Vector2.RIGHT * startDirection * walkSpeed
	

#MOVEMENT_____________________________________________________________________-
func _move(delta : float) :
	super._move(delta)
	
	var dir : float = sign(velocity.x)
	
	if _shouldTurnAround(dir) : 
		dir = -dir
		horizRay.target_position = Vector2(horizRayBaseDir.x*dir, horizRayBaseDir.y)
		searchRay.target_position = Vector2(searchRayBaseDir.x*dir, searchRayBaseDir.y)
		velocity.x *= -1
		treadsAnim.speed_scale = treadsSpeed * dir
		_newEyePosition()
	move_and_slide()
	#apply_force(Vector2.RIGHT * delta * walkSpeed * direction)
	
	if !customSearchlightBehavior :
		searchLight.flip_h = dir < 0
			
			
			
			
			

func _shouldTurnAround(dir : float) -> bool :
	if dir > 0 && !rightVertRay.is_colliding() :
		return true
	elif dir < 0 && !leftVertRay.is_colliding() :
		return true
	elif horizRay.is_colliding() && horizRay.get_collider() != null && (!horizRay.get_collider().is_in_group("Player") || turnOnPlayer):
		return true
	
	return false



#Animation_________________________________________________________________
func _newEyePosition() :
	super._newEyePosition()
	if velocity.x < 0 :
		eyesCurEnd.x *= -1
