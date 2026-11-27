extends Marker2D

@export var object_to_spawn: PackedScene

var spawned_obj: Node2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_object()

func _process(delta: float) -> void:
	if spawned_obj == null:
		spawn_object()

func spawn_object() -> void:
	if object_to_spawn == null:
		return
		
	if spawned_obj != null:
		return
	
	spawned_obj = object_to_spawn.instantiate()
	add_child(spawned_obj)
