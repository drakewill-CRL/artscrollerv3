extends Control

signal art_tapped(icon)

func _ready() -> void:
	var randomColor = Color.from_hsv(randf(), randf(), 0.25)
	$Control/clrBG.color = randomColor

func SetArt(dataitem):
	if dataitem == null:
		return
		
	$Control/txrArt.texture = load("res://ArtPack/" + dataitem.Folder + "/" + dataitem.Filename)
	#$Control/btnArt.icon = load("res://ArtPack/" + dataitem.Folder + "/" + dataitem.Filename)
	$Control/lblName.text = dataitem.DisplayName # + " : " + dataitem.Filename # for debugging
	$Control/lblDataSet.text = dataitem.DataSet
	
	var actualSize = $Control/txrArt.get_rect().size
	#var actualSize = $Control/btnArt.size
	$Control/clrBG.size.y = $Control/txrArt.position.y + actualSize.y + 40
	#$Control/clrBG.size.y = $Control/btnArt.position.y + actualSize.y + 40
	custom_minimum_size = Vector2(720, $Control/clrBG.size.y)
	
func tap(inputEvent):
	#art_tapped.emit($Control/btnArt.icon)
	if inputEvent is InputEventMouseButton and inputEvent.double_click:
		art_tapped.emit($Control/txrArt.texture)
