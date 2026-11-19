class_name Entity
extends RigidBody2D


@export var maxHP : int = 10
var curHP : int = maxHP

var deletaOnDeath : bool = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
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
