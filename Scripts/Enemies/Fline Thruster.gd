extends RayCast2D

#This is a smaller part of the full Flying enemy
#THis is put on each thruster, and animates them when in contact with other objects
#It maintains a timer for how long its collided with something, and tweens the thruster based on that

var dust : Sprite2D

var transitionSpeed : float = 2
var colT : float

var baseOffset : Vector2
var colOffset : Vector2
@export var colOffsetMult : float = 0.5

var thrusterSprite : Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dust = $Thruster/Dust
	thrusterSprite = $Thruster
	baseOffset = thrusterSprite.position
	colOffset = baseOffset * colOffsetMult


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_colliding() :
		colT += delta * transitionSpeed
		if colT > 1 :
			colT = 1
	else :
		colT -= delta * transitionSpeed
		if colT < 0 :
			colT = 0
	
	thrusterSprite.position = (1-colT)*baseOffset + colT*colOffset
	dust.modulate.a = colT
	
