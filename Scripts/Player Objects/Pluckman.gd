extends CharacterBody2D

# States Pluckman can be in
enum State { IDLE, FOLLOWING, THROWN }

# Collision Variables
@onready var physicsCollider: CollisionShape2D = $CollisionShape2D
@onready var pickupCollider: CollisionShape2D = $PickupArea/CollisionShape2D

# Variables Pluckman has (can be edited for testing)
@export var pluckman_state: State = State.IDLE
@export var follow_speed: float = 200.0
@export var jump_velocity: float = -400.0
@export var jump_threshold: float = 50.0

#Throwing Variables
@export var friction: float = 1200.0

var targetPos: Vector2
var isThrown: bool = false

func _ready():
	#Turns off physics collider and sets the target position to where it is on spawn
	physicsCollider.set_deferred("disabled", true)
	targetPos = global_position

func _physics_process(delta: float) -> void:
	# Changes what to do depending on state (For idle currently nothing but can be changed if we add pluckman spawners)
	if pluckman_state == State.FOLLOWING:
		following_commands(delta)
	elif pluckman_state == State.THROWN:
		throwing_commands(delta)
	
	move_and_slide()

#If State = 1
func following_commands(delta: float):
	# Gets direction it should be moving by looking at previous target with current pos
	var directionX = targetPos.x - global_position.x
	
	# Checks if it's moving left or right
	if abs(directionX) > 5.0:
		velocity.x = sign(directionX) * follow_speed
	else:
		velocity.x = move_toward(velocity.x, 0, follow_speed)
	
	# Checks if it is on the floor and player is above a certain height
	if is_on_floor() and (global_position.y - targetPos.y) > jump_threshold:
		velocity.y = jump_velocity
	
	# Gravity function
	if not is_on_floor():
		velocity += get_gravity() * delta

#If State = 2
func throwing_commands(delta: float):
	# If not on the floor use gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	elif is_on_floor():
		# If on the floor (need to potentially update becuase having issues reading before moving to target on player//Reading as on floor before throw even occurs)
		velocity.x = move_toward(velocity.x, 0, friction * delta) # Adds friction to throw
		isThrown = false # Changes throw bool
		if velocity == Vector2.ZERO: # Sets back to idle when it stops moving // If we add a state for when it can be commanded should go here
			change_state(0)
			physicsCollider.set_deferred("disabled", true)
			pickupCollider.set_deferred("disabled", false)

# Function for throwing 
func throw(throwVelocity: Vector2) -> void:
	velocity = throwVelocity
	isThrown = true

func change_state(index: int):
	#Test code for later
	
	#match index:
		#0:
			#physicsCollider.set_deferred("disabled", true)
			#pickupCollider.set_deferred("disabled", false)
		#1:
			#physicsCollider.set_deferred("disabled", false)
			#pickupCollider.set_deferred("disabled", true)
		#2:
			#physicsCollider.set_deferred("disabled", false)
			#pickupCollider.set_deferred("disabled", true)
		#_:
			#print("error: not a state")
	
	pluckman_state = index

# Function on picking up pluckman
func _on_pickup_area_body_entered(body: Node2D) -> void:
	# Checks if it's player (can probably be better than this)
	if body.is_in_group("Player"):
		if pluckman_state != State.FOLLOWING and body.pluckmanArray.size() < 3: # Checks if the pluckman not following and if the array is the right size (should probably change to a get variable)
			# Turns on physics collider, adds the pluckman, turns off pickup collider (a little redundant but can be changed later)
			physicsCollider.set_deferred("disabled", false)
			pluckman_state = State.FOLLOWING
			body.add_pluckman(self)
			pickupCollider.set_deferred("disabled", true)
