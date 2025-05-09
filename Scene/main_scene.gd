extends Node2D

var artControlPL = preload("res://Controls/ArtControl.tscn")
var zoomControlPL = preload("res://Controls/ZoomedArtControl.tscn")

var itemsAtOnce = 10
var allItems = []

#TODO: 
# Enable an options screen to toggle files on/off dynamically
# pretty up the UI some.
# find other open data sets (or make some)

#NOTE:
# To make a new pack for Artscroller:
# - Make a new Godot Project.
# - Put one folder in it, named ArtPack
# - inside the ArtPack folder, put any subfolders desired. At least one is necessary
# - - Beside all the files you want to display, the subfolder needs a metadata.json file
# - - metadata.json needs a PackName value, and an DataItems array.
# - - each DataItem needs 3 properties: Filename, Folder, DisplayName. DataSet is applied on load.
# - - Once complete, Export the project to a .pck file (I use a Web export to enable the button)
# I use separate apps/scripts I've written to manage the large amount of files and pull the name from
# another source - an open access CSV, the MAME xml for its game lists, etc.

@onready var vbox = $ScrollContainer/VBoxContainer
var scrollbar

func _ready() -> void:
	OS.request_permissions() #This and the Manage_External_Storage permissions are currently needed
	scrollbar = $ScrollContainer.get_v_scroll_bar()
	scrollbar.value_changed.connect(CheckForAdd)
	
	LoadPCKs()
	
	AddMoreArt()

func LoadPCKs():
	#step 1: find PCKs, either manually selected or automatically found
	var pcks = []
	var dlPath = OS.get_system_dir(OS.SYSTEM_DIR_DOWNLOADS)
	var files = DirAccess.get_files_at(dlPath)
	for file in files:
		if file.ends_with("pck"):
			pcks.append(dlPath + "/" + file)
			print("found PCK at " + file)
	
	for pck in pcks:
		var loaded = ProjectSettings.load_resource_pack(pck)
		if (loaded):
			pass
			
	var savedPrefs = Globals.LoadData("user://disabled.json")
	if savedPrefs == null:
		savedPrefs = {}
	if !savedPrefs.has("disabled"):
		savedPrefs.disabled = []
	# Step 2: Get metadata into memory from loaded PCKs
	var subfolders = DirAccess.get_directories_at("res://ArtPack")
	for sf in subfolders:
		var metadata = JSON.parse_string(FileAccess.get_file_as_string("res://ArtPack/" + sf + "/metadata.json")) #read json file.
		if !Globals.allSets.has(metadata.PackName):
			Globals.allSets.append(metadata.PackName)
			if !savedPrefs.disabled.has(metadata.PackName):
				Globals.enabledSets.append(metadata.PackName)
		for item in metadata.DataItems:
			item.DataSet = metadata.PackName
		allItems.append_array(metadata.DataItems)

func PickItem():
	if allItems.is_empty():
		return
	
	if Globals.enabledSets.size() == 0:
		Globals.enabledSets = Globals.allSets.duplicate()
		
	var pickedItem = allItems.pick_random()
	while (!Globals.enabledSets.has(pickedItem.DataSet)):
		pickedItem = allItems.pick_random()
	return pickedItem

func ShowZoomedArt(texture):
	$ZoomedArtControl.SetTexture(texture)
	$ZoomedArtControl.position.x = 0

#func _input_ignore(event: InputEvent) -> void:
	#if event is not InputEventMouseButton:
		#return
	#if event.button_index == MOUSE_BUTTON_WHEEL_UP or event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
		#return
		#
	#for control in $ScrollContainer/VBoxContainer.get_children():
		#var txr = control.get_node('Control/txrArt')
		#var rect = txr.get_rect()
		#if rect.has_point(event.global_position):
			#ShowZoomedArt(txr.texture)
			#return

func ButtonPushed(btn):
	ShowZoomedArt(btn)

func AddMoreArt():
	for i in itemsAtOnce:
		var artDisplay = artControlPL.instantiate()
		artDisplay.art_tapped.connect(ButtonPushed)
		vbox.add_child(artDisplay)
		artDisplay.SetArt(PickItem())

func CheckForAdd(newVal):
	if newVal > scrollbar.max_value - 1300: #Assuming this is pixels.
		AddMoreArt()
		
func Options():
	var optScene = preload("res://Scene/Options.tscn")
	add_child(optScene.instantiate())
