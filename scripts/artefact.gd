extends Node
class_name Artefact

signal changed

var path: String

func init(file_path):
	path = file_path

static func get_type_name():
	return "Artefact"
