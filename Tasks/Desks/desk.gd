extends Node2D

@onready var white = $VariantWhite
@onready var black = $VariantBlack

func _ready() -> void:
	randomize()
	var isBlack = (randi() % 100) > GameManager.mental_health
	
	$VariantBlack.visible = isBlack
	$VariantWhite.visible = !isBlack
