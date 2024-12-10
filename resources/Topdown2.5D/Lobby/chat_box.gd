extends VBoxContainer

@onready var chat_display = $RichTextLabel
@onready var chat_edit = $LineEdit
var chat: Array[Dictionary] = []

func update_chat_display():
	chat_display.clear() 
	for message in chat: 
		var formatted_message = format_message(message)
		chat_display.add_text(formatted_message+'\n')

func format_message(message:Dictionary):
	return "[{timestamp}] {sender}: {content}".format(message)

func add_chat_and_update_display(chat):
	chat.append({
		"timestamp": Time.get_datetime_string_from_system(),
		"sender": "Player1",
		"receiver": "Team1", # Optional, can be null for "All Chat"
		"chat_type": "Team Chat", # Enum or string: "All Chat", "Team Chat", "Whisper"
		"content": chat
	})
	update_chat_display()

func _on_line_edit_text_submitted(new_text):
	add_chat_and_update_display(new_text)
	chat_edit.clear()
