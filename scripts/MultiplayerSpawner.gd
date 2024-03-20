extends MultiplayerSpawner


# Called when the node enters the scene tree for the first time.
func _ready():
	dir_contents("res://levels/")

func dir_contents(path):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.split('.')[1] == "tscn":
				add_spawnable_scene("res://levels/" + file_name)
			file_name = dir.get_next()
