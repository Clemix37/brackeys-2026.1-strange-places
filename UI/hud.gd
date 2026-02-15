extends CanvasLayer

@onready var mental_health_bar: ProgressBar = %MentalHealthBar
# TEST Buttons
@onready var mh_100: Button = $VBoxContainer/MarginContainer/HBoxContainer/MH100
@onready var mh_70: Button = $VBoxContainer/MarginContainer/HBoxContainer/MH70
@onready var mh_40: Button = $VBoxContainer/MarginContainer/HBoxContainer/MH40
@onready var mh_15: Button = $VBoxContainer/MarginContainer/HBoxContainer/MH15
@onready var mh_0: Button = $VBoxContainer/MarginContainer/HBoxContainer/MH0

func _ready() -> void:
	GameManager.mental_health_changed.connect(_update_mental_health_bar)
	# TEST buttons
	mh_100.pressed.connect(set_mh_100)
	mh_70.pressed.connect(set_mh_70)
	mh_40.pressed.connect(set_mh_40)
	mh_15.pressed.connect(set_mh_15)
	mh_0.pressed.connect(set_mh_0)

func _update_mental_health_bar(mental_health: int) -> void:
	mental_health_bar.value = mental_health
	_update_mental_health_fill_color()

## Updates the mental_health_bar fill color
## TODO see if transition between values can be fluidified 
func _update_mental_health_fill_color() -> void:
	var mental_health: int = GameManager.mental_health
	var fill_style = mental_health_bar.get_theme_stylebox("fill").duplicate()
	if mental_health > 70:
		# 5EDC8A
		fill_style.bg_color = Color("5EDC8A")
		pass
	elif mental_health > 40:
		# F2C94C
		fill_style.bg_color = Color("F2C94C")
		pass
	elif mental_health > 15:
		# F2994A
		fill_style.bg_color = Color("F2994A")
		pass
	elif mental_health > 0:
		# EB5757
		fill_style.bg_color = Color("EB5757")
		pass
	else:
		# 6C3EB8
		fill_style.bg_color = Color("6C3EB8")
		pass
	mental_health_bar.add_theme_stylebox_override("fill", fill_style)

func set_mh_100() -> void:
	GameManager.set_mental_health(100)

func set_mh_70() -> void:
	GameManager.set_mental_health(70)

func set_mh_40() -> void:
	GameManager.set_mental_health(40)

func set_mh_15() -> void:
	GameManager.set_mental_health(15)

func set_mh_0() -> void:
	GameManager.set_mental_health(0)
