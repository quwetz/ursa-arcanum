extends Area2D

var player: CollisionObject2D = null


func can_see_player() -> bool:
	return player != null


func _on_PlayerDetector_body_entered(body):
	player = body


func _on_PlayerDetector_body_exited(body):
	player = null
