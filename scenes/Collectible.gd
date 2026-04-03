extends Area3D

func _on_body_entered(body):
	if body.is_in_group("Player"):
		if body.has_method("add_item_to_inventory"):
			body.add_item_to_inventory()

		queue_free()
