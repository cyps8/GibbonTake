class_name Credits extends Control

func BackButton():
	visible = false

func _on_label_meta_clicked(meta: Variant) -> void:
	var urlRegex = RegEx.new()
	urlRegex.compile('^(ftp|http|https|www)://[^ "]+$')
	var result = urlRegex.search(str(meta))
	if  result:
		OS.shell_open(str(meta))
	
