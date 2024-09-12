extends RichTextLabel

var speed = 50  # Default falling speed
var word = ""
var current_index = 0


func _ready():
	add_to_group("falling_words")
	position.y = -50  # Start position above the screen
	bbcode_enabled = true  # Enable BBCode interpretation

func _process(delta):
	position.y += speed * delta
	if position.y > get_viewport_rect().size.y:
		queue_free()

func set_word(new_word):
	word = new_word
	current_index = 0
	update_display()

func set_fall_speed(new_speed):
	speed = new_speed

func check_char(typed_char):
	if current_index < word.length() and typed_char == word[current_index]:
		current_index += 1
		update_display()
		return true
	return false

func is_completed():
	return current_index == word.length()

func get_word():
	return word

func update_display():
	var completed_part = word.substr(0, current_index)
	var remaining_part = word.substr(current_index)
	text = "[color=green]" + completed_part + "[/color]" + remaining_part

func _init():
	bbcode_enabled = true
	fit_content = true
	autowrap_mode = TextServer.AUTOWRAP_OFF
	custom_minimum_size = Vector2(100, 30)  # Adjust as needed
	add_theme_font_size_override("normal_font_size", 32)
	#add_theme_color_override("default_color", Color.WHITE)
