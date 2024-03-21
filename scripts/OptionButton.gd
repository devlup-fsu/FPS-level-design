extends OptionButton


func _ready():
	dir_contents("res://levels/")

func dir_contents(path):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.split('.')[1] == "tscn":
				add_item(file_name.split('.')[0])
			file_name = dir.get_next()
