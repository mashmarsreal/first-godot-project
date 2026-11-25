extends RigidBody2D

#func _ready() -> void:
	# Give a slight random horizontal pop and upward hop on spawn
	#apply_central_impulse(Vector2(randf_range(-50.0, 50.0), -100.0))
	#
	## Add a bit of spin so it tumbles and lands on a flat edge
	#angular_velocity = randf_range(-4.0, 4.0)
