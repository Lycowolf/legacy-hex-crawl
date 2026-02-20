extends AudioStreamPlayer

@export var songs: Array[AudioStream]
var current_song_idx = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.stream = songs[current_song_idx]
	self.play()

func change_song(offset: int) -> void:
	# `+ len(songs)` is there to handle negative offsets (modulo would return negative otherwise)
	self.current_song_idx = (current_song_idx + offset + len(songs)) % len(songs)
	self.stream = songs[current_song_idx]
	self.play()

func _on_finished() -> void:
	change_song(+1)	

# TODO: interface
#func _on_previous_song_pressed() -> void:
	#change_song(-1)
#
#func _on_next_song_pressed() -> void:
	#change_song(+1)
#
#func _on_music_slider_value_changed(value: float) -> void:
	#if value == %MusicSlider.min_value:
		#volume_db = -INF
	#else:
		#volume_db = value
