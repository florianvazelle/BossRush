extends Interactable

signal reload_taken()


func is_interactable():
	return true


func interact():
	reload_taken.emit()
	queue_free()
