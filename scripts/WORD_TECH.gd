extends Node2D

var FallingWord = preload("res://levels/word based levels/WORD_TECH LEVEL/WORD-LABEL.tscn")
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
	"PYTHON", "JAVASCRIPT", "GODOT", "C++", "HTML", "CSS", "ALGORITHM", "FUNCTION", "VARIABLE", "REACT", "NODEJS",
	"ANGULAR", "VUE", "KOTLIN", "SWIFT", "ANDROID", "IOS", "GITHUB", "GIT", "BITBUCKET", "JIRA", "DOCKER", "KUBERNETES", 
	"LINUX", "WINDOWS", "MACOS", "VIRTUALIZATION", "CONTAINER", "CLOUD", "AWS", "AZURE", "GCP", "FIREBASE", "DATABASE", 
	"MYSQL", "SQLITE", "MONGODB", "REDIS", "NOSQL", "FRONTEND", "BACKEND", "DEVOPS", "CI", "CD", "DEPLOYMENT", "SERVER", 
	"CLIENT", "API", "REST", "GRAPHQL", "JSON", "XML", "SCRIPTING", "AUTOMATION", "ROBOTICS", "BLOCKCHAIN", "AI", 
	"MACHINELEARNING", "DEEPLEARNING", "NEURALNETWORK", "AR", "VR", "CYBERSECURITY", "HACKING", "ENCRYPTION", "DECRYPTION",
	"FIREWALL", "VPN", "SSL", "TLS", "CERTIFICATE", "HTML5", "CSS3", "RESPONSIVE", "SEO", "SEMANTIC", "SCSS", "LESS", 
	"BOOTSTRAP", "TAILWIND", "WEBPACK", "BABEL", "TYPESCRIPT", "RUBY", "RAILS", "DART", "FLUTTER", "GO", "RUST", "JAVA",
	"SPRING", "HIBERNATE", "C#", "UNITY", "UNREAL", "XR", "BIGDATA", "DATAANALYTICS", "QUERIES", "INDEX", "CACHING", 
	"OPTIMIZATION", "DEBUGGING", "PROFILE", "TESTING", "UNITTEST", "JUNIT", "MOCK", "STAGING", "PRODUCTION", "RELEASE",
	"PATCH", "UPGRADE", "MAINTENANCE", "REFACTOR", "MODULARITY", "DESIGNPATTERN", "SOLID", "AGILE", "SCRUM", "KANBAN",
	"SASS", "PWA", "INTERNETOFTHINGS", "SMARTDEVICES", "WEBSOCKET", "MESSAGEQUEUE", "STREAMING", "APACHE", "NGINX", 
	"TOMCAT", "CIRCUIT", "NETWORK", "SUBNET", "TCP", "UDP", "HTTP", "HTTPS", "WEBRTC", "PEERTOPEER", "LOADBALANCER",
	"CACHE", "COOKIE", "SESSION", "LOCALSTORAGE", "INDEXEDDB", "WEBWORKERS", "SERVICEWORKER", "NOTIFICATIONS", 
	"WEBASSEMBLY", "SHELL", "BASH", "ZSH", "POWER", "TERMINAL", "COMMANDLINE", "SCHEDULER", "KERNEL", "VIRTUALMACHINE",
	"DOCKERIMAGE", "YAML", "JSONPARSER", "DEBUGGER", "MONITORING", "OBSERVABILITY", "LOGGING", "TRACING", "METRICS",
	"INFRASTRUCTURE", "TERRAFORM", "ANSIBLE", "PUPPET", "CHEF", "SALTSTACK", "CLOUDFUNCTION", "LAMBDA", "EDGE", "GATEWAY",
	"TRANSLATION", "INTERNATIONALIZATION", "LOCALIZATION", "MULTITHREADING", "CONCURRENCY", "PARALLELISM", "THREADPOOL", 
	"EVENTLOOP", "ASYNC", "PROMISE", "CALLBACK", "FETCH", "AXIOS", "SOCKET", "DATABASESHARDING", "REPLICATION", 
	"FAULTTOLERANCE", "RESILIENCE", "MIRRORING", "LOADTESTING", "PERFORMANCE", "LATENCY", "THROUGHPUT", "CACHEHIT",
	"CACHEMISS", "SOFTWAREENGINEERING", "SYSTEMARCHITECTURE", "MICROSERVICES", "STATEFUL", "STATELESS", "ORCHESTRATION",
	"AUTOSCALING", "SCALE", "SERVICEMESH", "MONOREPO", "POLYREPO", "GITFLOW", "GITOPS", "CI/CD", "CONTINUOUSINTEGRATION", 
	"CONTINUOUSDELIVERY", "CONTINUOUSDEPLOYMENT", "DEVELOPER", "PROGRAMMER", "ARCHITECT", "ENGINEER", "ADMINISTRATOR",
	"SYSTEMADMIN", "DEVOPSENGINEER", "FRONTENDDEVELOPER", "BACKENDDEVELOPER", "FULLSTACKDEVELOPER", "TECHLEAD", 
	"PROJECTMANAGER", "PRODUCTMANAGER", "SOLUTIONARCHITECT", "SITEARCHITECT"
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
