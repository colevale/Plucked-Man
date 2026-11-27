class_name Player
extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var throw_point: Marker2D = $ThrowPoint

# Level Camera Variables
# Be sure to use camera in Player Object Script, OPTIONAL - in end game can make an onready if we are using one giant scene, it's just here becuase of testing
@export var camera: Camera2D

@export var curr_spawn: Marker2D

# Pluckman Variables
@export var pluckmanAmount: int = 3
@export var spacing: int = 15
@export var throw_speed: float = 400.0
@export var throw_angle: float = -40.0

var pluckmanPos_hist: Array[Vector2] = [] # Position array
var pluckmanArray: Array[Node2D] = [] # Pluckman Node array
var thrownPluckmen: Array[Node2D] = []

var heldPluckman: Node2D
var holdingPluckman: bool = false
var facingDirection: int = 1 #1 or -1 depending on direction

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump and falling through platforms, currently using layer 5 as a method for platforms you can drop down from, but can be changed
	if Input.is_action_just_pressed("jump"):
		if Input.is_action_pressed("crouch"):
			set_collision_mask_value(5, false)
		elif is_on_floor():
			velocity.y = JUMP_VELOCITY
			set_collision_mask_value(5, true)
		else:
			set_collision_mask_value(5, true)
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	
	if direction > 0:
		animated_sprite.flip_h = false
		facingDirection = 1
	elif direction < 0:
		animated_sprite.flip_h = true
		facingDirection = -1
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# PLUCKMAN MECHANICS
	
	# Pluckman Movement
	# Updates movement of each pluckman in the movement array
	if abs(velocity.x) > 0: 
		pluckmanPos_hist.push_front(global_position)
		var max_history = (pluckmanArray.size() + 1) * spacing
		if pluckmanPos_hist.size() > max_history:
			pluckmanPos_hist.pop_back()

	# Updates pluckman placement to target positions based on movement array
	for i in range(pluckmanArray.size()):
		var target_index = (i+1) * spacing
		if target_index < pluckmanPos_hist.size():
			pluckmanArray[i].targetPos = pluckmanPos_hist[target_index]
			
		# function to make sure that pluckmen know if player is grounded or not
		if not is_on_floor():
			pluckmanArray[i].change_playerGrounded(false)
		elif is_on_floor():
			pluckmanArray[i].change_playerGrounded(true)
	
	#Pluckman Throwing
	if pluckmanArray.size() > 0:
		if Input.is_action_just_pressed("shoot") and holdingPluckman == false:
			holdingPluckman = true
			heldPluckman = pluckmanArray.pop_front()
			thrownPluckmen.push_front(heldPluckman)
			heldPluckman.global_position = throw_point.global_position
			var angle = deg_to_rad(throw_angle)
			var throw_velocity = Vector2(cos(angle) * throw_speed * facingDirection, sin(angle) * throw_speed)
			heldPluckman.throw(throw_velocity)
			heldPluckman.change_state(2) #Thrown State
			holdingPluckman = false

	if thrownPluckmen.size() > 0:
		if Input.is_action_just_pressed("recall"):
			for i in range(thrownPluckmen.size()):
				var currentPluckman = thrownPluckmen.pop_front()
				currentPluckman.change_state(1)
				currentPluckman.position = $ThrowPoint.global_position
				pluckmanArray.push_back(currentPluckman)

	move_and_slide()

# Room Detector Function
func _on_room_detector_area_entered(area: Area2D) -> void:
	var collision_room = area.get_parent()
	camera.change_room(collision_room)
	var spawner = collision_room.find_child("Player Spawner", false, true)
	if spawner:
		if curr_spawn != null:
			curr_spawn.deactivate()
		curr_spawn = spawner
		curr_spawn.set_active()

# Add Pluckman Function
func add_pluckman(newPluckman: Node2D) -> void:
	pluckmanArray.append(newPluckman)
	
func remove_pluckman(pluckmanToRemove: Node2D) -> void:
	for i in range(pluckmanAmount):
		if pluckmanArray.size() > 0 and pluckmanToRemove == pluckmanArray[i]:
			pluckmanArray.remove_at(i)
			print("found pluckman")
			break
		elif thrownPluckmen.size() > 0 and pluckmanToRemove == thrownPluckmen[i]:
			thrownPluckmen.remove_at(i)
			print("found pluckman")
			break

func addMorePluckman():
	var currentPluckmenHeld = pluckmanArray.size() + thrownPluckmen.size()
	if currentPluckmenHeld < pluckmanAmount:
		return true
	else:
		return false

func die():
	# try to find a way to set reference pluckmen back to idle and to remove the player reference
	
	if pluckmanArray.size() > 0:
		for i in range(pluckmanArray.size()):
			pluckmanArray[i].change_state(0)
			pluckmanArray[i].remove_player()
	elif thrownPluckmen.size() > 0:
		for i in range(thrownPluckmen.size()):
			thrownPluckmen[i].change_state(0)
			thrownPluckmen[i].remove_player()
	
	queue_free()

# OPTIONAL if camera will always be in final game just set it as an onready instead
func get_camera(currCamera: Node2D) -> void:
	camera = currCamera
