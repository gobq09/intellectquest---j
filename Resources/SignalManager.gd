extends Node

signal graphics_mode(mode)

signal inventory_select(id)
signal buff(effect)
signal item_used(state)

signal settings_updated
signal quest_selected(id)
signal quest_updated

signal map_changed(scene)
signal tutorial_ended
signal player_defeated
signal interface_changed

signal ui_tutorial(type)
signal trigger_ui
signal ui_tutorial_end

signal movement_disabled
signal movement_enabled

signal camera_move_to(position : Vector2)

signal dialogue_enter
signal dialogue_exit

signal move_player(direction : String, duration : int)
signal player_anim(animation: String)
