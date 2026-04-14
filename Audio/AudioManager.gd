extends Node

var music_player: AudioStreamPlayer = null
var music_player_old: AudioStreamPlayer = null
var ambience_player: AudioStreamPlayer = null	
var ambience_player_old: AudioStreamPlayer = null
var ambience_players: Array = []
var original_music_db: float = 0.0
var last_music_time := 0.0
var music_cooldown := 5.0

func _ready():
	SignalManager.play_music.connect(_on_play_music)
	SignalManager.play_sfx.connect(_on_play_sfx)
	SignalManager.play_ambience.connect(_on_play_ambience)
	SignalManager.stop_music.connect(stop_music_fade)
	SignalManager.stop_ambience.connect(stop_all_ambience_instant)
	
	last_music_time = 0.0
	
#region AUDIO LIBRARY
var music_library = {
	"main_theme": preload("res://Audio/Music/IntelliQuest.mp3"),
	"exploration_themes": preload("res://Audio/Music/Exploration Themes/Steps Beyond the Shore.mp3"),
	"battle_theme": preload("res://Audio/Music/Battle Themes/Clash of Wits.mp3"),
	"greymoor_town_theme": preload("res://Audio/Music/Town Themes/Greymoor Town.mp3"),
	"win_combat": [preload("res://Audio/Music/Event Themes/Triumph.mp3")]
}

var sfx_library = {
	"glitch_sfx": [preload("res://Audio/SFX/UI sfx/Glitch Sound.mp3")],
	"click_sfx": [preload("res://Audio/SFX/UI sfx/click.wav")],
	"confirm_sfx": [preload("res://Audio/SFX/UI sfx/Confirm.wav")],
	"bag_open": [preload("res://Audio/SFX/UI sfx/bag-open.mp3")],
	"bag_close": [preload("res://Audio/SFX/UI sfx/bag-close.mp3")],
	"page_flips": [preload("res://Audio/SFX/UI sfx/pageflip1.mp3"),
			preload("res://Audio/SFX/UI sfx/pageflip2.mp3"),
			preload("res://Audio/SFX/UI sfx/pageflip3.mp3")
	]
}

var ambience_library = {
	"nature_ambience": [
			preload("res://Audio/ambience/chribonn-nature-216798.mp3"),
			preload("res://Audio/ambience/empressnefertitimumbi-nature-birds-singing-217212.mp3"),
			preload("res://Audio/ambience/soundreality-spring-forest-nature-2-377741.mp3")
	],
	"beach_ambience": [
			preload("res://Audio/ambience/Ocean with Seaguls.mp3")
	],
	"eerie_ambience": [
			preload("res://Audio/ambience/Eerie Ambient Sound Effect.mp3")
	]
}

#endregion

#region MUSIC
func play_music(stream: AudioStream):
	var target_db = get_music_db()
	
	if music_player:
		music_player_old = music_player
	
	music_player = AudioStreamPlayer.new()
	music_player.bus = "Music"
	music_player.stream = stream
	music_player.volume_db = -30
	add_child(music_player)
	music_player.play()
	
	var tween_in = create_tween()
	tween_in.set_trans(Tween.TRANS_SINE)
	tween_in.set_ease(Tween.EASE_OUT)
	tween_in.tween_property(music_player, "volume_db", target_db, 2.5)
	
	if music_player_old:
		var tween_out = create_tween()
		tween_out.set_trans(Tween.TRANS_SINE)
		tween_out.set_ease(Tween.EASE_IN)
		
		tween_out.tween_property(music_player_old, "volume_db", -40, 2.5)
		await tween_out.finished
		
		if music_player_old:
			music_player_old.stop()
			music_player_old.queue_free()
			music_player_old = null
	
func get_music_db():
	return AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))
	
func _on_play_music(track_name: String):
	if not music_library.has(track_name):
		return
	
	var data = music_library[track_name]
	
	if data is Array:
		play_music(data.pick_random())
	else:
		play_music(data)
		
#func duck_music():
	#if music_player:
		#original_music_db = music_player.volume_db
		
		#var tween = create_tween()
		#tween.tween_property(music_player, "volume_db", -25, 0.3)
		
#func restore_music():
	#if music_player:
		#var tween = create_tween()
		#tween.tween_property(music_player, "volume_db", original_music_db, 0.3)

func stop_music_fade():
	if music_player:
		var tween = create_tween()
		tween.tween_property(music_player, "volume_db", -40, 1.0)
		await tween.finished
		music_player.stop()
		music_player.queue_free()
		music_player = null
#endregion

#region SFX
func _on_play_sfx(sfx_name: String):
	if not sfx_library.has(sfx_name):
		return
	
	var sounds = sfx_library[sfx_name]
	var stream = sounds.pick_random()
	
	var player = AudioStreamPlayer.new()
	player.bus = "Sound Effects"
	player.stream = stream
	player.volume_db = 0.0
	
	add_child(player)
	player.play()
	
	player.connect("finished", Callable(self, "_on_sfx_finished").bind(player))
	
func _on_sfx_finished(player: AudioStreamPlayer):
	if player:
		player.queue_free()
	
#endregion

#region AMBIANCE
func play_ambience(stream: AudioStream):
	if ambience_player and ambience_player.stream == stream:
		return

	if ambience_player:
		ambience_player_old = ambience_player

	ambience_player = AudioStreamPlayer.new()
	ambience_player.bus = "Ambience"
	ambience_player.stream = stream
	ambience_player.volume_db = -40
	add_child(ambience_player)
	ambience_player.play()

	# fade in new ambience
	var tween_in = create_tween()
	tween_in.tween_property(ambience_player, "volume_db", 0, 1.5)

	# fade out old ambience
	if ambience_player_old:
		var old = ambience_player_old
		var tween_out = create_tween()
		tween_out.tween_property(old, "volume_db", -40, 1.5)
		await tween_out.finished

		old.stop()
		old.queue_free()
		ambience_player_old = null
	
func _on_play_ambience(ambience_name: String):
	if not ambience_library.has(ambience_name):
		return

	var audio_list = ambience_library[ambience_name]

	# CASE 1: single stream (not array)
	if audio_list is AudioStream:
		play_ambience(audio_list)
	else:
		play_ambience_layer(audio_list.pick_random())

	# CASE 2: array (layer system)
	play_ambience_layer(audio_list.pick_random())
		
func play_ambience_layer(stream: AudioStream):
	var player = AudioStreamPlayer.new()
	player.bus = "Ambience"
	player.stream = stream
	player.volume_db = -15
	player.pitch_scale = randf_range(0.95, 1.05)
	add_child(player)
	player.play()
	ambience_players.append(player)
	
	player.connect("finished", Callable(self, "_on_ambience_finished").bind(player))
	
func _on_ambience_finished(player: AudioStreamPlayer):
	if ambience_players.has(player):
		ambience_players.erase(player)
	player.queue_free()

func stop_ambiance_fade():
	if not ambience_player:
		return

	var tween = create_tween()
	tween.tween_property(ambience_player, "volume_db", -40, 1.0)
	await tween.finished

	ambience_player.stop()
	ambience_player.queue_free()
	ambience_player = null

func stop_all_ambience_instant():
	if ambience_player:
		ambience_player.stop()
		ambience_player.queue_free()
		ambience_player = null
	for player in ambience_players:
		player.stop()
		player.queue_free()
	ambience_players.clear()
	
func switch_zone_ambience(stream: AudioStream):
	stop_ambiance_fade()
	play_ambience(stream)
#endregion
