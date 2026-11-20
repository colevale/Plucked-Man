extends Camera2D

# Give Starting Room
@export var room: TileMapLayer

# Give Player Character
@export var player: CharacterBody2D

#Other Variables
@export var horizontal_dead_zone = 30
@export var vertical_dead_zone = 30
@export var follow_speed = 200.0 #CHANGE TO PLAYER SPEED OR ELSE IT WILL LOOK WEIRD

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_camera_limits()
	
func _physics_process(delta: float) -> void:
	update_camera_position(delta)

# Updates Room Information
func change_room(newRoom: TileMapLayer):
	room = newRoom
	setup_camera_limits()

# Setups the Cameras Limits
func setup_camera_limits():
	# Gathers information to create limits
	global_position = player.global_position
	var used_rect = room.get_used_rect()
	var cell_size = room.tile_set.tile_size
	var map_width = used_rect.size.x * cell_size.x
	var map_height = used_rect.size.y * cell_size.y
	
	# Sets Limits
	limit_left = used_rect.position.x * cell_size.x
	limit_right = limit_left + map_width
	limit_top = used_rect.position.y * cell_size.y
	limit_bottom = limit_top + map_height
	
	#Test Script to see limits
	#print("Tilemap Limits: left: ", limit_left ,", right: ", limit_right ,", top: ", limit_top ,", bottom: ", limit_bottom)
	#print("Tilemap size (px): ", map_width, "x ", map_height, "y")

# Updates and Moves According to the Player
func update_camera_position(delta):
	# Error Check
	if not player:
		return
	
	#Gets Position Variables
	var player_pos = player.global_position
	var camera_pos = global_position
	
	# Creates Target Variable
	var target_pos = camera_pos
	
	# Shifts camera x variables to not go over dead zone
	if abs(player_pos.x - camera_pos.x) > horizontal_dead_zone:
		target_pos.x = player_pos.x
	
	# Shifts Camera y variables to not go over dead zone
	if player_pos.y < camera_pos.y - vertical_dead_zone:
		target_pos.y = player_pos.y
	elif player_pos.y > camera_pos.y + vertical_dead_zone:
		target_pos.y = player_pos.y
	
	# X pos movement
	position.x = move_toward(position.x, target_pos.x, follow_speed * delta)
	
	# Y pos movement
	if player_pos.y > camera_pos.y:
		position.y = move_toward(position.y, target_pos.y, player.velocity.y * delta)
	else:
		position.y = move_toward(position.y, target_pos.y, follow_speed * delta)
