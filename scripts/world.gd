extends Node

@onready var main_menu = $CanvasLayer/MainMenu
@onready var address_entry = $CanvasLayer/MainMenu/MarginContainer/VBoxContainer/AddressEntry
@onready var hud = $CanvasLayer/HUD
@onready var health_bar = $CanvasLayer/HUD/HealthBar
@export var level_name: String

var red_team_size = 0
var blue_team_size = 0

const Player = preload("res://scenes/player.tscn")
const PORT = 9999
var enet_peer = ENetMultiplayerPeer.new()

func load_level():
	print("level_name: ", level_name)
	var level = load("res://levels/" + level_name + ".tscn")
	add_child(level.instantiate())

func _unhandled_input(event):
	if Input.is_action_just_pressed("quit"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE else Input.MOUSE_MODE_VISIBLE

func _on_host_button_pressed():
	main_menu.hide()
	hud.show()
	
	var option_button = $CanvasLayer/MainMenu/MarginContainer/VBoxContainer/HBoxContainer/OptionButton
	
	if option_button.selected == -1:
		return
		
	level_name = option_button.get_item_text(option_button.selected)
	
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)

	load_level()

	add_player(multiplayer.get_unique_id())
	
	## commenting removes upnp, instead uses just normal port OS level forwarding
	# upnp_setup()

func _on_join_button_pressed():
	main_menu.hide()
	hud.show()
	
	if address_entry.text == "":
		address_entry.text = "localhost"
	
	enet_peer.create_client(address_entry.text, PORT)
	multiplayer.multiplayer_peer = enet_peer

func add_player(peer_id):
	var player = Player.instantiate()
	player.name = str(peer_id)
	
	add_child(player)
	
	if red_team_size > blue_team_size:
		player.set_team.rpc("blue")
		blue_team_size += 1
	else:
		player.set_team.rpc("red")
		red_team_size += 1
	
	if player.is_multiplayer_authority():
		player.health_changed.connect(update_health_bar)

func remove_player(peer_id):
	var player = get_node_or_null(str(peer_id))
	if player:
		if player.team == "red":
			red_team_size -= 1
		elif player.team == "blue":
			blue_team_size -= 1
		player.queue_free()

func update_health_bar(health_value):
	health_bar.value = health_value

func _on_multiplayer_spawner_spawned(node):
	if node.is_multiplayer_authority():
		node.health_changed.connect(update_health_bar)

func upnp_setup():
	var upnp = UPNP.new()
	
	var discover_result = upnp.discover()
	assert(discover_result == UPNP.UPNP_RESULT_SUCCESS, \
		"UPNP Discover Failed! Error %s" % discover_result)

	assert(upnp.get_gateway() and upnp.get_gateway().is_valid_gateway(), \
		"UPNP Invalid Gateway!")

	var map_result = upnp.add_port_mapping(PORT)
	assert(map_result == UPNP.UPNP_RESULT_SUCCESS, \
		"UPNP Port Mapping Failed! Error %s" % map_result)
	
	print("Success! Join Address: %s" % upnp.query_external_address())
