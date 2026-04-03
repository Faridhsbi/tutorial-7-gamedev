extends RayCast3D

@export var crosshair: ColorRect
@onready var interaction_label: Label = $"../../../HUD/InteractionLabel"
func _process(_delta):
	if crosshair:
		crosshair.color = Color.WHITE

	interaction_label.text = ""

	if is_colliding():
		var collider = get_collider()
		if collider is Interactable:
			if crosshair:
				crosshair.color = Color.GREEN
			
			if "prompt_message" in collider:
				interaction_label.text = collider.prompt_message
			else:
				interaction_label.text = "Press [E] to interact"
			
			if Input.is_action_just_pressed("interact"):
				collider.interact()
