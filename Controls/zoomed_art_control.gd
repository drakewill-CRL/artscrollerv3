extends Node2D

var start_distance = 0
var touch_points = []
var start_zoom = 0

var can_pan = true
var can_zoom = true

var h_offset = 0
var pan_speed = 1

var currentCenter = Vector2(0, 0)

func SetTexture(tex):
	$txrArt.texture = tex
	$txrArt.scale = Vector2(1.0, 1.0)
	currentCenter = Vector2(360, 640)
	recenter()

func handle_touch(event: InputEventScreenTouch):
	if event.pressed:
		touch_points[event.index] = event.position
	else:
		touch_points.erase(event.index)
		
	if touch_points.size() == 2:
		var touch_point_positions = touch_points.values()
		start_distance = touch_point_positions[0].distance_to(touch_point_positions[1])
		
		start_zoom = position
		
	elif  touch_points.size() <2:
			start_distance = 0

func handle_drag(event: InputEventScreenDrag):
	touch_points[event.index] = event.position
	if touch_points.size() == 1:
		if can_pan:
			h_offset -= event.relative.x * pan_speed
			#transform.origin.z -= event.relative.y * pan_speed # z doesn't exist here
	elif touch_points.size() == 2:
		var touch_point_positions = touch_points.values()
		var current_distance =  touch_point_positions[0].distance_to(touch_point_positions[1])
		
		var zoom_factor =  start_distance / current_distance
		if can_zoom:
			position = start_zoom / zoom_factor

func _input(event: InputEvent) -> void:
	if event is InputEventMagnifyGesture:
		$txrArt.scale *= event.factor
		if $txrArt.scale.x < 0.2:
				$txrArt.scale = Vector2(0.2, 0.2)
		elif $txrArt.scale.x > 4:
			$txrArt.scale = Vector2(4,4)
		recenter()
		return
		
	#TODO: on drag event, check screen_relative and adjust currentCenter by that amount
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			$txrArt.scale += Vector2(0.1, 0.1)

		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			if $txrArt.scale.x > 0.2:
				$txrArt.scale -= Vector2(0.1, 0.1)
		recenter()

func recenter():
	var boxSize = $txrArt.get_rect().size
	$txrArt.position = currentCenter - (boxSize / 2)

func close():
	position.x = -8000
