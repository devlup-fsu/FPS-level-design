@tool

extends StaticBody3D

enum BlockColor {
	RED,
	BLUE,
	DARKRED,
	DARKBLUE,
	WHITE,
	GRAY,
	BLACK
}

var hue_dict = {
	BlockColor.RED : Vector3(0.03,-0.2,-0.2),
	BlockColor.BLUE : Vector3(0.64,-0.2,-0.2),
	BlockColor.DARKRED : Vector3(0.03,-0.2,-0.7),
	BlockColor.DARKBLUE : Vector3(0.64,-0.2,-0.7),
	BlockColor.WHITE : Vector3(0,-1,-0.4),
	BlockColor.GRAY : Vector3(0,-1,-0.7),
	BlockColor.BLACK : Vector3(0,-1,-0.9),
}

@onready var mat: Material = $MeshInstance3D.mesh.material

@export var color: BlockColor = BlockColor.GRAY:
	set(value):
		color = value
		print(hue_dict[color])
		set_color()

@export var size: Vector3 = Vector3.ONE:
	set(value):
		size = value
		$MeshInstance3D.mesh.size = size
		$CollisionShape3D.shape.size = size

func set_color():
	print(mat)
	print($MeshInstance3D.mesh.get_surface_count())
	# $MeshInstance3D.set_surface_override_material(0, load("res://prefabs/Block.tres"))
	$MeshInstance3D.mesh.material.set_shader_parameter("Hue", hue_dict[color])

# Called when the node enters the scene tree for the first time.
func _ready():
	set_color()
