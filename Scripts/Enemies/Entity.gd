class_name Entity
extends RigidBody2D

#General class for all entities, including enemies, and the player/pikmin?
#Basically just handles health and death



@export var maxHP : int = 10
var curHP : int = maxHP

var deletaOnDeath : bool = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

	
	
func _updateHP(dir : int) :
	curHP -= dir
	if curHP <= 0 :
		_onDeath()
	if curHP > maxHP :
		curHP = maxHP
		
	print(name + ", " + str(curHP))

func _onDeath() :
	if deletaOnDeath :
		queue_free()
