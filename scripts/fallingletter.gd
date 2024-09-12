extends Label

var speed = 200  # Default falling speed
var letter = ''
var rng = RandomNumberGenerator.new()

func _ready():
	add_to_group("falling_letters")
	rng.randomize()
	letter = char(rng.randi_range(65, 90))  # Random letter A-Z
	text = letter
	position.y = -50  # Start position above the screen

func _process(delta):
	position.y += speed * delta
	if position.y > get_viewport_rect().size.y:
		queue_free()

func set_fall_speed(new_speed):
	speed = new_speed
