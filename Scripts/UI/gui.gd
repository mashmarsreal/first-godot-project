extends Node
@onready var HealthBar: TextureProgressBar = $HBoxContainer/TextureProgressBar

func _ready() -> void:
	HealthBar.value = 100

func changeVal(val: float):
	HealthBar.value = val
