class_name Projectile
extends Node2D



@export var lifetime : float = 20
var direction : Vector2
@export var speed : float = 1

var isFired : bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !isFired :
		return
	
	global_position += direction * speed * delta
	
	lifetime -= delta
	if lifetime < 0 :
		queue_free()
		
func _shoot(dir : Vector2, startPos : Vector2) :
	direction = dir.normalized()
	global_position = startPos
	isFired = true
