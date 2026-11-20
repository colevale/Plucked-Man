extends Area2D

# Each Button Must Be Connected to 1 Barrier
@export var barrier: TileMapLayer

# When Colliding with Button Remove Barrier and Sets Collision Object to be Disabled
# If we want button pushed animation add it here
func _on_body_entered(body: Node2D) -> void:
	barrier.buttonPressed()
	$CollisionShape2D.set_deferred("disabled", true)
