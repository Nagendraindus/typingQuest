extends Node2D

var FallingWord = preload("res://levels/word based levels/WORD_SPACE/WD_LABEL_SPACE.tscn")
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
	"GALAXY", "STAR", "PLANET", "MOON", "ASTEROID", "METEOR", "COMET", "NEBULA", "CONSTELLATION", 
	"SUPERNOVA", "BLACKHOLE", "GRAVITY", "ORBIT", "COSMOS", "SATELLITE", "ROCKET", "ASTRONAUT", 
	"SPACESHIP", "SOLAR", "LUNAR", "ECLIPSE", "TELESCOPE", "UNIVERSE", "QUASAR", "PULSAR", 
	"SPACETIME", "INTERSTELLAR", "INTERGALACTIC", "WORMHOLE", "BIGBANG", "ASTRONOMY", "SPACECRAFT", 
	"SPACEX", "NASA", "SATURN", "JUPITER", "MARS", "EARTH", "URANUS", "NEPTUNE", "VENUS", 
	"MERCURY", "PLUTO", "EXOPLANET", "KUIPER", "OORTCLOUD", "ANDROMEDA", "MAGNETAR", "SINGULARITY", 
	"HORIZON", "ESCAPEVELOCITY", "LIGHTYEAR", "EVENTHORIZON", "ACCELERATION", "ESCAPEVELOCITY", 
	"ASTROBIOLOGY", "ATMOSPHERE", "COSMICRAYS", "COSMOLOGY", "DARKENERGY", "DARKMATTER", 
	"DEEPSPACE", "DIMENSION", "DWARFPLANET", "ESCAPEVELOCITY", "EUROPA", "GRAVITATIONALWAVES", 
	"HALO", "HUBBLETELESCOPE", "INFINITY", "INTERPLANETARY", "LAUNCH", "MAGNETICFIELD", "METEORITE", 
	"MULTIVERSE", "PARALLELUNIVERSE", "PHASE", "PROBE", "PULSAR", "QUANTUM", "REENTRY", 
	"ROVER", "SATELLITE", "SINGULARITY", "SLEEPER", "SOLARSYSTEM", "SPACEDEBRIS", "SPACETIME", 
	"SPACESHUTTLE", "SPACEWALK", "SPAGHETTIFICATION", "SPECTRUM", "STARCLUSTER", "STARGAZING", 
	"STELLAR", "SUBORBITAL", "SUNSPOT", "SUPERNOVA", "TELEMETRY", "THRUST", "THRUSTER", 
	"TIDALFORCE", "TIMEDILATION", "TRANSMISSION", "TRANSPONDERS", "TRAJECTORY", "UNIDENTIFIEDFLYINGOBJECT", 
	"UNIVERSE", "VACUUM", "VARIABLESTAR", "VOYAGER", "XENON", "ZENITH", "ZEROPOINTENERGY", 
	"ZODIAC", "SPACEFORCE", "INTERSTELLARMEDIUM", "SPACEWEATHER", "EXTRASOLAR", "GRAVITATION", 
	"SPACESUIT", "EARTHRISE", "BLUEGIANT", "WHITEGIANT", "REDGIANT", "COSMICMICROWAVE", "DWARFSTAR", 
	"EQUATOR", "INTERGALACTICSPACE", "ROTATION", "REVOLUTION", "EQUINOX", "SOLSTICE", "ALBEDO", 
	"COSMICBACKGROUND", "CORE", "CRATER", "EQUATOR", "SOLARWIND", "HELIOSPHERE", "CORONA", 
	"FLARE", "GEOLOGICAL", "COSMICDUST", "PLANETOID", "TERRAFORM", "HYDROGEN", "HELIUM", 
	"RADIOSIGNAL", "TELEMETRY", "EXOSPHERE", "STELLARNURSERY", "PROTOPLANET", "ESCAPEVELOCITY", 
	"THERMOSPHERE", "EXPLORATION", "FOOTPRINT", "INTERSPACE", "LAGRANGE", "MICROMETEORITE", 
	"ROSETTASTONE", "TOUCHDOWN", "COMMANDER", "MODULE", "FUELTANK", "CARGOSHIP", "GRAVITON", 
	"ORBITAL", "SUBSPACE", "ATMOSPHERIC", "ESCAPEVECTOR", "ARTIFICIALSATELLITE", "CANADARM", 
	"DELTAIV", "DISCOVERY", "ENDEAVOUR", "INERTIA", "JUNO", "LAUNCHPAD", "NEWTON", "SOLARRADIATION", 
	"SPECTRALANALYSIS", "TETHER", "UNMANNED", "VACUUM", "VELOCITY", "APHELION", "PERIHELION", 
	"BINARYSTAR", "CHANDRA", "EXPLORER", "HYDROSYSTEM", "LIGHTSPEED", "ORBITER", "SPIN", 
	"VOYAGER", "ZONATION", "ZENITH", "ALTAIR", "ASTRONAUTICAL", "SPACEGYROSCOPE", "ANGSTROM", 
	"PROGRADE", "RETROGRADE", "LEO", "APOGEE", "PARSEC", "HYDRATION", "CELESTIAL", "INTERSOLAR", 
	"TITAN", "METEORSHOWER", "GALACTICPLANE", "OBLATE", "SPACEFARING", "NEUTRONSTAR", "PLANETARYNEBULA", 
	"RADIATIONBELT", "SPECTROSCOPE", "SPINOFF", "SPIRALARMS", "SUBATOMIC", "TERRESTRIAL", 
	"TIDALWAVE", "TRANSLUNAR", "UPLINK", "ZENITH", "BACKSCATTER", "CORETEMPERATURE", 
	"MAGNETICPOLE", "NEUTRINO", "PARTICLE", "SPACECAPSULE", "DEEPIMPACT", "MISSIONCONTROL", 
	"COSMICCONSCIOUSNESS", "SATELLITECOMMUNICATION", "APOLLO", "DEIMOS", "PHOBOS", "PROXIMACENTAURI", 
	"DELTAVELOCITY", "PLANETARYSCIENCE", "OPPORTUNITY", "AERONAUTICS", "ANTARES", "ATLANTIS", 
	"BLACKBODY", "COMMANDMODULE", "DELTAWINGS", "EXPEDITION", "FORMATIONFLYING", "GAMMA", 
	"GANYMEDE", "GODDARD", "GREENWICH", "HARVESTMOON", "HYPERDRIVE", "INCLINATION", "JUPITERMISSION", 
	"KERBAL", "LAUNCHESCAPE", "MISSION", "NEBULARTHERY", "QUADRANT", "REDPLANET", "REENTRYVELOCITY", 
	"SAGITTARIUS", "SILICON", "THRUSTVECTOR", "UNMANNEDSPACE", "WATERICE", "XPLANE", "APOLLOPROGRAM", 
	"BEYOND", "CHARON", "CISLUNAR", "CREWED", "DELTAV", "EUROPA", "HELIOCENTRIC", "METHANE", 
	"POLARAXIS", "QUANTUMFLUCTUATION", "PLANETARYDEFENSE", "EXOMOON", "FULLMOON", "IONIZATION", 
	"SPACEANOMALY", "SWARM", "VESPER", "XANTHE", "ACCRETION", "DECOHERENCE", "FARSIDE", 
	"IONDRIVE", "MICROGRAVITY", "NANOTECHNOLOGY", "PERSEVERANCE", "QUADRATURE", "RADIOTRANSMISSION", 
	"SYNCHRONOUS", "LUNARMODULE", "WARPDRIVE", "ZENITHAL", "APOAPSIS", "COSMONAUT", "PEREGRINE", 
	"POLARORBIT", "SPACECURVATURE", "SUBLUMINAL", "TRAJECTORYCORRECTION"
];

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
