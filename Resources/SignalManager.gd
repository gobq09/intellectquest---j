extends Node

signal graphics_mode(mode)

signal inventory_select(id)
signal buff(effect)
signal item_used(state)

signal settings_updated
signal quest_selected(id)
signal quest_updated
signal quest_start(quest_id: String)
signal quest_advance()
signal quest_completed(quest_id)
signal enemy_killed(enemy_id: String)
signal npc_talked(npc_id: String)
signal area_entered(area_id: String)

signal map_changed(scene)
signal tutorial_ended
signal player_defeated
signal interface_changed
signal show_hud

signal ui_tutorial(type)
signal ui_tutorial_end

signal movement_disabled
signal movement_enabled

signal camera_move_to(position : Vector2)

signal dialogue_enter
signal dialogue_exit
signal dialogue_skipped
signal dialogue_skipped_ended

signal move_player(direction : String, duration : int)
signal player_anim(animation: String)

signal move_to_marker(marker_name: String, duration: float)
signal send_marker(global_position: Vector2, duration: float)

signal look_at_player(node_name: String)
signal send_player_position(node_name: String, global_pos: Vector2)
signal stop_looking_at_player(node_name: String)

signal player_look_at(node_name: String)
signal send_node_position(global_pos: Vector2)
signal player_stop_looking

signal pearl_anim(animation: String)
signal move_pearl_to(marker_name: String, duration: float)
signal pearl_marker(global_position: Vector2, duration: float)

signal entered_chunk(chunk_name: String)
signal show_chunk(chunks: Array)

signal play_music(track_name: String)
signal play_sfx(sfx_name: String)
signal play_ambience(ambience_name: String)
signal stop_music()
signal stop_ambience()

signal spawn_point_set(spawn_point: String)
