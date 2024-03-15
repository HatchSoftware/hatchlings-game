extends Node


func play_sfx_at_pos(sound: AudioStream, pos: Vector2) -> void:
	if sound != null && pos != null:
		var s = AudioStreamPlayer2D.new()
		s.stream = s
		s.position = pos
		get_tree().root.add_child(s)
		s.connect("finished", func(): s.queue_free())
		s.play()
