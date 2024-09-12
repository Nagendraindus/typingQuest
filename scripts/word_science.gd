extends Node2D

var FallingWord = preload("res://levels/word based levels/WORD_SCIENCE/WD_LABEL_SCIENCE.tscn")
var score = 0
var spawn_timer = 0
var spawn_interval = 3.0
var min_spawn_interval = 1.0
var rng = RandomNumberGenerator.new()
var initial_fall_speed = 50
var max_fall_speed = 150
var current_fall_speed = initial_fall_speed
var difficulty_increase_rate = 0.1
var time_elapsed = 0
var words = [
	"PHYSICS", "CHEMISTRY", "BIOLOGY", "ASTRONOMY", "BOTANY", "ZOOLOGY", "GEOLOGY", "ECOLOGY", "METEOROLOGY", 
	"GENETICS", "ELECTRICITY", "MAGNETISM", "KINETIC", "POTENTIAL", "EINSTEIN", "NEWTON", "GRAVITY", "ENERGY", 
	"FORCE", "MASS", "SPEED", "VELOCITY", "LIGHT", "WAVE", "SOUND", "OPTICS", "REFLECTION", "REFRACTION", 
	"ELEMENT", "ATOM", "MOLECULE", "PROTON", "NEUTRON", "ELECTRON", "ION", "ACID", "BASE", "PH", "SALT", 
	"POLYMER", "REACTANT", "PRODUCT", "SOLID", "LIQUID", "GAS", "PLASMA", "VOLTAGE", "CURRENT", "RESISTANCE", 
	"FREQUENCY", "WAVELENGTH", "AMPLITUDE", "MAGNET", "COMBUSTION", "RADIATION", "DNA", "RNA", "CHROMOSOME", 
	"GENOME", "CELL", "MITOSIS", "MEIOSIS", "MICROORGANISM", "EVOLUTION", "NATURALSELECTION", "EARTHQUAKE", 
	"VOLCANO", "TECTONIC", "ATMOSPHERE", "BIOSPHERE", "OXYGEN", "HYDROGEN", "CARBON", "NITROGEN", "SULFUR", 
	"HELIX", "REACTION", "THERMODYNAMICS", "BIOLOGY", "EVOLUTION", "ASTROPHYSICS", "SPECTROMETER", 
	"SPECTROSCOPY", "PHOTON", "QUANTUMMECHANICS", "GENERALRELATIVITY", "SIMPLEMACHINE", "LEVER", "WHEEL", 
	"INCLINEDPLANE", "SCIENTIFICMETHOD", "DATAANALYSIS", "HYPOTHESIS", "THEORY", "EXPERIMENT", "LABORATORY", 
	"PHARMACEUTICAL", "BIOTECHNOLOGY", "ELECTROMAGNETIC", "MICROSCOPE", "TELESCOPE", "PARTICLE", "MASS", 
	"LIGHTYEAR", "ASTEROID", "METEOR", "COMET", "PLANET", "STAR", "GALAXY", "BLACKHOLE", "UNIVERSE", 
	"BIODIVERSITY", "NATURALRESOURCES", "ECOSYSTEM", "CLIMATECHANGE", "GLOBALWARMING", "CARBONFOOTPRINT"
]

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
	
	if time_elapsed >= 10:
		increase_difficulty()
		time_elapsed = 0
	
	if spawn_timer >= spawn_interval:
		spawn_word()
		spawn_timer = 0

func _unhandled_input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		var typed_char = char(event.unicode).to_upper()
		if check_word(typed_char):
			typing_sound.play()

func spawn_word():
	var word = FallingWord.instantiate()
	word.position.x = rng.randf_range(50, get_viewport_rect().size.x - 50)
	word.set_word(words[rng.randi() % words.size()])
	word.set_fall_speed(current_fall_speed)
	add_child(word)

func check_word(typed_char):
	for word_node in get_tree().get_nodes_in_group("falling_words"):
		if word_node.check_char(typed_char):
			if word_node.is_completed():
				score += word_node.get_word().length()
				$score.text = "Score: " + str(score)
				word_node.queue_free()
			return true
	return false

func increase_difficulty():
	current_fall_speed = min(current_fall_speed * 1.1, max_fall_speed)
	spawn_interval = max(spawn_interval * 0.95, min_spawn_interval)

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/word based levels/LEVELS.tscn")
