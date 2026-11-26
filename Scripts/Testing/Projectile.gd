class_name Projectile
extends Node2D

#Very basic projectile. Linearly goes a direction, and eventually deletes itself

@export var lifetime : float = 20
var direction : Vector2
@export var speed : float = 1

var isFired : bool = false

var contactDamage : int = 1


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


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") :
		body._updateHP(contactDamage)
