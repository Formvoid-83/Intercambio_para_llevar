extends Node
class_name LetterDatabase

var letters: Array[LetterOpenData] = []

func load_letters(path := "res://Data/letters.json") -> void:
	letters.clear()

	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Failed to load letters.json")
		return

	var data :Dictionary = JSON.parse_string(file.get_as_text())
	if data == null:
		push_error("Invalid JSON in letters.json")
		return

	for entry in data["letters"]:
		letters.append(
			LetterOpenData.new(
				entry["greetings"],
				entry["content"],
				entry["from"],
				entry["commission"],
				entry["gender"]
			)
		)
