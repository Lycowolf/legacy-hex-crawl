@tool
extends Label
class_name ConditionWidget

signal condition_critical

@export var condition_name: String:
	set(x):
		condition_name = x
		text = x

@export var value: int = 0 :
	set(x):
		value = clampi(x, 0, limit)
		update()
		self.visible = Engine.is_editor_hint() or value > 0
		
		if value == limit and not Engine.is_editor_hint():
			condition_critical.emit(condition_name)
		
@export var limit: int = 5:
	set(x):
		limit = x
		value = clampi(value, 0, limit)
		update()

@export_enum('Blue', 'BlueWavy', 'Red', 'RedWavy', 'Orange', 'OrangeWavy',  'Green', 'GreenWavy')
var color: String = 'Blue':
	set(x):
		color = x
		$Progress.texture_progress.region = color2rect(x)

func color2rect(color_name:String) -> Rect2:
	match color_name:
		'Blue': return Rect2(208., 860., 160., 8.)
		'BlueWavy': return Rect2(976., 860., 160., 8.)
		'Red': return Rect2(400., 860. ,160. ,8.)
		'RedWavy': return Rect2(1168., 860. ,160. ,8.)
		'Orange': return Rect2(592., 860. ,160. ,8.)
		'OrangeWavy': return Rect2(1360., 860. ,160. ,8.)
		'Green': return Rect2(784., 860. ,160. ,8.)
		'GreenWavy': return Rect2(1552., 860. ,160. ,8.)
		_: return Rect2(0., 0., 0., 0.)

func update():
	if not $Progress.is_node_ready():
		await ready
		
	$Progress.max_value = limit
	$Progress.value = value
