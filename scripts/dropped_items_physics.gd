extends RigidBody2D

func _integrate_forces(state):
	var gravity = Vector2(0, 98)
	apply_central_force(gravity)

func _on_body_entered(body):
	print("coco")
	if body.type == CharacterBody2D:
		queue_free()
# fazer isto /\
