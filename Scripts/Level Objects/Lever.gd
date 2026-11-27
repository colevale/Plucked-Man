extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var barrier: TileMapLayer
@export var spriteRadius: float = 16.0

var clickPos: Vector2
var inArea: bool = false
var flipped: bool = false

func _ready() -> void:
	animated_sprite_2d.flip_h = false

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("click") and inArea and !flipped:
		clickPos = get_global_mouse_position()
		if position.distance_to(clickPos) < spriteRadius:
			leverSwitched()

func leverSwitched():
	flipped = true
	animated_sprite_2d.flip_h = true
	barrier.buttonPressed()

# can change to be both minion or player
func _on_flip_distance_body_entered(body: Node2D) -> void:
	if body.is_in_group("Minion"):
		print("entered")
		inArea = true

func _on_flip_distance_body_exited(body: Node2D) -> void:
	if body.is_in_group("Minion"):
		print("exited")
		inArea = false
