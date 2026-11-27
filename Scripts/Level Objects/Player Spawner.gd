extends Marker2D

@export var level_scene: Node2D
@export var object_to_spawn: PackedScene
@export var camera: Node2D

# Set to current instance of player
@export var spawned_obj: Node2D

var spawnerRoom: TileMapLayer
var spawner_active = false

func _ready() -> void:
	spawnerRoom = self.get_parent()

func _process(delta: float) -> void:
	if spawned_obj == null:
		var checkPlayer = camera.givePlayer()
		if checkPlayer != null:
			spawned_obj = checkPlayer
		else:
			if spawner_active:
				spawn_object()

func spawn_object() -> void:
	if object_to_spawn == null:
		return
		
	if spawned_obj != null:
		return
	
	spawned_obj = object_to_spawn.instantiate()
	spawned_obj.get_camera(camera)
	add_child(spawned_obj)
	camera.updatePlayer(spawned_obj)

func set_active():
	spawner_active = true
	
func deactivate():
	spawner_active = false
