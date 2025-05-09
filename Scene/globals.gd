extends Node

var allSets = []
var enabledSets = []


#Convenience function
func LoadData(fileName):
	var recentFile = FileAccess.open(fileName, FileAccess.READ)
	if (recentFile == null):
		return
	else:
		var json = JSON.new()
		json.parse(recentFile.get_as_text())
		var info = json.get_data()
		recentFile.close()
		return info

#Convenience function
func SaveData(fileName, dictionary):
	var recentFile = FileAccess.open(fileName, FileAccess.WRITE)
	if (recentFile == null):
		print(FileAccess.get_open_error())
		return
	
	var json = JSON.new()
	recentFile.store_string(json.stringify(dictionary))
	recentFile.close()
