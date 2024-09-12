extends Node2D

var FallingLetter = preload("res://levels/letter based/label.tscn")
var score = 0
var spawn_timer = 0
var spawn_interval = 1.0  # Initial spawn interval
var min_spawn_interval = 0.3  # Minimum spawn interval
var rng = RandomNumberGenerator.new()
var initial_fall_speed = 150  # Initial falling speed
var max_fall_speed = 210  # Maximum falling speed
var current_fall_speed = initial_fall_speed
var difficulty_increase_rate = 0.1  # Increase difficulty every 10 seconds
var time_elapsed = 0

# Add AudioStreamPlayer
var typing_sound: AudioStreamPlayer

func _ready():
	
	rng.randomize()
	$score.text = "Score: 0"
	
	
	# Set up the AudioStreamPlayer
	typing_sound = AudioStreamPlayer.new()
	add_child(typing_sound)
	typing_sound.stream = preload("res://assets/music/typing_sound.wav")  # Adjust path as needed
	typing_sound.volume_db = -10  # Adjust volume as needed

func _process(delta):
	spawn_timer += delta
	time_elapsed += delta
	
	# Increase difficulty
	if time_elapsed >= 10:  # Every 10 seconds
		increase_difficulty()
		time_elapsed = 0
	
	if spawn_timer >= spawn_interval:
		spawn_letter()
		spawn_timer = 0

func _unhandled_key_input(event):
	if event.pressed and event.unicode >= 65 and event.unicode <= 90:
		var typed_letter = char(event.unicode)
		if check_letter(typed_letter):
			typing_sound.play()

func spawn_letter():
	var letter = FallingLetter.instantiate()
	letter.position.x = rng.randf_range(50, get_viewport_rect().size.x - 50)
	letter.set_fall_speed(current_fall_speed)
	add_child(letter)

func check_letter(typed_letter):
	for letter in get_tree().get_nodes_in_group("falling_letters"):
		if letter.letter == typed_letter:
			score += 1
			$score.text = "Score: " + str(score)
			letter.queue_free()
			return true
	return false

func increase_difficulty():
	# Increase fall speed
	current_fall_speed = min(current_fall_speed * 1.1, max_fall_speed)
	
	# Decrease spawn interval
	spawn_interval = max(spawn_interval * 0.95, min_spawn_interval)


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/word based levels/LEVELS.tscn")
