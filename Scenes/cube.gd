extends StaticBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func place_cube(marker):
	var new_pos = marker.global_position
	position = Vector3(int(new_pos.x),int(new_pos.y),int(new_pos.z))
	print(position)
	
	
