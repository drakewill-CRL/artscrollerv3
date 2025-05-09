extends Node2D

func _ready():
	for set in Globals.allSets:
		var chk = CheckBox.new()
		chk.text = set
		chk.button_pressed = Globals.enabledSets.has(set)
		chk.toggled.connect(chkToggled)
		$sc/vb.add_child(chk)

func Close():
	queue_free()

func chkToggled(newState):
	var chk = get_viewport().gui_get_focus_owner()
	if (newState):
		Globals.enabledSets.append(chk.text)
	else:
		var idx = Globals.enabledSets.find(chk.text)
		if idx != -1:
			Globals.enabledSets.remove_at(idx)
	
	var disabledSets = Globals.allSets.duplicate()
	for es in Globals.enabledSets:
		var idx = disabledSets.find(es)
		if  idx > -1:
			disabledSets.remove_at(idx)
	Globals.SaveData("user://disabled.json", {disabled = disabledSets})
