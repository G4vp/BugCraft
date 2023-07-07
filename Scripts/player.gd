extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 5.0
const LOOKAROUND_SPEED = 0.01

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
# Player rotation axes
var rot_x: float = 0
var rot_y: float = 0

var marker : Marker3D
var raycast : RayCast3D

func _ready():
	marker = get_node("Camera3D/Marker3D")
	raycast = get_node("Camera3D/RayCast3D")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _physics_process(delta):
	player_movement(delta)
	move_and_slide()

func _input(event):
	if event is InputEventMouseMotion:
		player_camera(event)
	if event is InputEventMouseButton && event.button_mask == 1:
		action_destroy_block()
	if event is InputEventMouseButton && event.button_mask == 2:
		action_place_block()

func action_place_block():	
# Do Something
	var cube = preload("res://Scenes/cube.tscn").instantiate()
	cube.place_cube(marker)
	get_parent().add_child(cube)
	
func action_destroy_block():
	var node_hit = raycast.get_collider()
	if(node_hit != null && node_hit.has_method("destroy_cube")):
		node_hit.destroy_cube()
	
func player_camera(event):
	# modify accumulated mouse rotation
	rot_x -= event.relative.x * LOOKAROUND_SPEED
	rot_y -= event.relative.y * LOOKAROUND_SPEED
	
	rot_y = clampf(rot_y, -PI/2, PI/2)
	
	transform.basis = Basis() # reset rotation
	rotate_object_local(Vector3(0, 1, 0), rot_x) # first rotate in Y
	rotate_object_local(Vector3(1, 0, 0), rot_y) # then rotate in X

func player_movement(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	# Handle Jump.
	if Input.is_action_just_pressed("key_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("key_left", "key_right", "key_up", "key_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

