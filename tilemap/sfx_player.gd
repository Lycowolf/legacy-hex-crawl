extends AudioStreamPlayer

# TODO: create a SFX manager as in Junkyard Jam?

@export var writing_snd: AudioStream

func play_stream(stream: AudioStream, volume_db_adjustment: float = 0.0) -> void:
	self.stream = stream
	self.volume_db = volume_db_adjustment
	self.play()

func _on_chronicle_new_chronicle_event() -> void:
	play_stream(writing_snd)
