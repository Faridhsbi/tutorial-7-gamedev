extends CharacterBody3D

var current_speed: float = 5.0
const WALK_SPEED: float = 5.0
const SPRINT_SPEED: float = 8.0
const CROUCH_SPEED: float = 2.5

const NORMAL_HEIGHT: float = 2.0
const CROUCH_HEIGHT: float = 1.5
const NORMAL_FOV: float = 75.0
const SPRINT_FOV: float = 85.0

@export var acceleration: float = 5.0
@export var gravity: float = 9.8
@export var jump_power: float = 5.0
@export var mouse_sensitivity: float = 0.15

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D
@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var ceiling_check: RayCast3D = $CeilingCheck

@onready var coin_label: Label = $HUD/MarginContainer/HBoxContainer/CoinLabel
@onready var coin_hud: Control = $HUD/MarginContainer/HBoxContainer
@onready var inventory_ui: HBoxContainer = %Inventory # Dipindah ke atas agar rapi

var coins_collected: int = 0
var max_coins: int = 5
var current_blocks: Array[String] = [] 
var camera_x_rotation: float = 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	var current_scene_name = get_tree().current_scene.name
	
	if current_scene_name == "Level2" or current_scene_name == "Level 2":
		coin_hud.visible = false
		if inventory_ui:
			inventory_ui.visible = true 
	else:
		coin_hud.visible = true
		if inventory_ui:
			inventory_ui.visible = false
		update_coin_ui()

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		head.rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		var x_delta = event.relative.y * mouse_sensitivity
		camera_x_rotation = clamp(camera_x_rotation + x_delta, -90.0, 90.0)
		camera.rotation_degrees.x = -camera_x_rotation

func _physics_process(delta):
	var is_crouching = Input.is_action_pressed("crouch")
	
	if not is_crouching and ceiling_check.is_colliding():
		is_crouching = true

	if is_crouching:
		current_speed = lerp(current_speed, CROUCH_SPEED, delta * 10.0)
		head.position.y = lerp(head.position.y, 0.5, delta * 10.0)
		collision_shape.shape.height = lerp(collision_shape.shape.height, CROUCH_HEIGHT, delta * 10.0)
		camera.fov = lerp(camera.fov, NORMAL_FOV, delta * 10.0)
	else:
		head.position.y = lerp(head.position.y, 1.5, delta * 10.0)
		collision_shape.shape.height = lerp(collision_shape.shape.height, NORMAL_HEIGHT, delta * 10.0)
		
		if Input.is_action_pressed("sprint"):
			current_speed = lerp(current_speed, SPRINT_SPEED, delta * 10.0)
			camera.fov = lerp(camera.fov, SPRINT_FOV, delta * 10.0)
		else:
			current_speed = lerp(current_speed, WALK_SPEED, delta * 10.0)
			camera.fov = lerp(camera.fov, NORMAL_FOV, delta * 10.0)

	var movement_vector = Vector3.ZERO
	if Input.is_action_pressed("movement_forward"): movement_vector -= head.basis.z
	if Input.is_action_pressed("movement_backward"): movement_vector += head.basis.z
	if Input.is_action_pressed("movement_left"): movement_vector -= head.basis.x
	if Input.is_action_pressed("movement_right"): movement_vector += head.basis.x

	movement_vector = movement_vector.normalized()

	velocity.x = lerp(velocity.x, movement_vector.x * current_speed, acceleration * delta)
	velocity.z = lerp(velocity.z, movement_vector.z * current_speed, acceleration * delta)

	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor() and not is_crouching:
		velocity.y = jump_power

	move_and_slide()

func add_item_to_inventory():
	if coins_collected < max_coins:
		coins_collected += 1
		update_coin_ui()

func update_coin_ui():
	if coin_label:
		coin_label.text = str(coins_collected) + " / " + str(max_coins)

func pick_up_block(color_name: String, ui_color: Color):
	current_blocks.append(color_name)
	print("Mengambil blok: ", color_name)
	
	var slot_index = current_blocks.size() - 1
	
	if inventory_ui and slot_index < inventory_ui.get_child_count():
		var slot = inventory_ui.get_child(slot_index) as ColorRect
		if slot:
			slot.color = ui_color
