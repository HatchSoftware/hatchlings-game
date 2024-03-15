extends Resource
class_name GameStats

var save_path := "res://save_file.json"
# var save_path := "user://save_file.json"

var high_score: int = 0:
	get:
		if score > high_score:
			high_score = score
		return high_score

var score: int = 0:
	set = set_score

signal score_changed(val: int)


func set_score(val: int):
	score = val
	score_changed.emit(val)


func reset():
	score = 0


func save_game():
	# var data = {"high_score": high_score}
	# var json_str := JSON.stringify(data)

	var file_access := FileAccess.open(save_path, FileAccess.WRITE)
	if not file_access:
		print("Could not save data", FileAccess.get_open_error())

	# file_access.store_line(json_str)
	file_access.store_32(high_score)
	print("file save ", high_score)
	file_access.close()


func load_save():
	if not FileAccess.file_exists(save_path):
		return

	var file_access := FileAccess.open(save_path, FileAccess.READ)
	high_score = file_access.get_32()
	print("file read ", high_score)
	file_access.close()
	# var json_str := file_access.get_line()
	# file_access.close()

	# var json := JSON.new()
	# var error := json.parse(json_str)

	# if error:
	# 	print("Failed to parse save file: ", json.get_error_message())
	#
	# if json.data && json.data.high_score:
	# 	var data: Dictionary = json.data
	# high_score = data.high_score
