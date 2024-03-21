@tool

extends StaticBody3D

enum BlockColor {
	RED,
	BLUE,
	DARKRED,
	DARKBLUE,
	WHITE,
	GRAY,
	BLACK,
	GREEN
}

var hue_dict = {
	BlockColor.RED : Vector3(0.03,-0.2,-0.2),
	BlockColor.BLUE : Vector3(0.64,-0.2,-0.2),
	BlockColor.DARKRED : Vector3(0.03,-0.2,-0.7),
	BlockColor.DARKBLUE : Vector3(0.64,-0.2,-0.7),
	BlockColor.WHITE : Vector3(0,-1,-0.4),
	BlockColor.GRAY : Vector3(0,-1,-0.7),
	BlockColor.BLACK : Vector3(0,-1,-0.9),
	BlockColor.GREEN : Vector3(0.4,0,0),
}

@onready var mat: Material = $MeshInstance3D.mesh.material

@export var color: BlockColor = BlockColor.GRAY:
	set(value):
		color = value
		# print(hue_dict[color])
		if Engine.is_editor_hint():
			set_color()

@export var size: Vector3 = Vector3.ONE:
	set(value):
		size = value
		$MeshInstance3D.mesh.size = size
		$CollisionShape3D.shape.size = size

@export_category("check this like it's a button 🧙‍♀️😵😮🦉✅")
@export var duplicate: bool:
	set(value):
		if Engine.is_editor_hint():
			var dup = load("res://prefabs/Block/Block.tscn").instantiate()
			dup.color = color
			dup.size = size
			dup.transform = transform
			get_parent().add_child(dup)
			dup.set_owner(get_tree().get_edited_scene_root())
			var selection = EditorInterface.get_selection()
			selection.clear()
			selection.add_node(dup)
			dup.name = "Block"

func set_color():
	# print(mat)
	#print($MeshInstance3D.mesh.get_surface_count())
	# $MeshInstance3D.set_surface_override_material(0, load("res://prefabs/Block.tres"))
	mat.set_shader_parameter("Hue", hue_dict[color])

# Called when the node enters the scene tree for the first time.
func _ready():
	set_color()


func _on_area_3d_body_entered(body):
	body.velocity.y = 40
	print("jump")
