extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("player entered")
		playerDeath(body)
	if body.is_in_group("Minion"):
		print("minion entered")
		minionDeath(body)


func playerDeath(body: Node2D):
	body._onDeath()
	
func minionDeath(body: Node2D):
	body._onDeath()
