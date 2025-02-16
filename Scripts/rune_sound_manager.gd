extends Node

# Sound directories
const RUNE_SOUNDS: Dictionary = {
	"activation": "res://Assets/Audio/SFX/Runes/Activation/",
	"deactivation": "res://Assets/Audio/SFX/Runes/Deactivation/",
	"hover": "res://Assets/Audio/SFX/Runes/Hover/"
}

# Cached randomizers
var _rune_randomizers: Dictionary[String, AudioStreamRandomizer] = {}

func _ready() -> void:
	if Global.testing:
		print("[RuneSoundManager] Initializing sound system...")
	_load_all_rune_sounds()

func _load_all_rune_sounds() -> void:
	for sound_type: String in RUNE_SOUNDS:
		if Global.testing:
			print("[RuneSoundManager] Loading sounds for type: ", sound_type, " from directory: ", RUNE_SOUNDS[sound_type])
		var randomizer: AudioStreamRandomizer = _create_randomizer(RUNE_SOUNDS[sound_type])
		if randomizer:
			_rune_randomizers[sound_type] = randomizer
			if Global.testing:
				print("[RuneSoundManager] Successfully loaded randomizer for type: ", sound_type)
		else:
			push_error("[RuneSoundManager] Failed to create randomizer for type: " + sound_type)

func _create_randomizer(sounds_dir: String) -> AudioStreamRandomizer:
	var dir: DirAccess = DirAccess.open(sounds_dir)
	if not dir:
		push_error("[RuneSoundManager] Could not open directory: " + sounds_dir + ". Error: " + str(DirAccess.get_open_error()))
		return null

	var randomizer: AudioStreamRandomizer = AudioStreamRandomizer.new()
	randomizer.random_pitch = 1.0
	randomizer.random_volume_offset_db = 0.0
	randomizer.playback_mode = AudioStreamRandomizer.PLAYBACK_RANDOM_NO_REPEATS

	var index: int = 0
	dir.list_dir_begin()
	var file_name: String = dir.get_next()

	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".ogg"):
			var file_path: String = sounds_dir.path_join(file_name)
			if Global.testing:
				print("[RuneSoundManager] Loading sound file: ", file_path)

			var sound: AudioStream = load(file_path)
			if sound and sound is AudioStreamOggVorbis:
				# Set loop for hover sounds
				if sounds_dir.ends_with("Hover/"):
					sound.loop = true
				randomizer.add_stream(index, sound)
				index += 1
				if Global.testing:
					print("[RuneSoundManager] Successfully loaded sound: ", file_path)
			else:
				push_error("[RuneSoundManager] Failed to load sound: " + file_path)

		file_name = dir.get_next()

	dir.list_dir_end()

	if index == 0:
		push_error("[RuneSoundManager] No .ogg files could be loaded from: " + sounds_dir)
		return null

	if Global.testing:
		print("[RuneSoundManager] Successfully loaded ", index, " sounds from ", sounds_dir)
	return randomizer

## Returns the AudioStreamRandomizer for the given sound type
## Returns null if the sound type doesn't exist or hasn't been loaded
func get_rune_randomizer(sound_type: String) -> AudioStreamRandomizer:
	if not _rune_randomizers.has(sound_type):
		push_error("[RuneSoundManager] No randomizer found for sound type: " + sound_type)
		return null
	if Global.testing:
		print("[RuneSoundManager] Returning randomizer for type: ", sound_type)
	return _rune_randomizers[sound_type]
