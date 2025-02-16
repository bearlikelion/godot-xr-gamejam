@tool
extends Node

# Global signals
signal place_on_pedistal(scene_string_or_base_rune: Variant)
signal podium_snapped(object_name: String)
signal rumble(hand: String, body_name: String)

# Start signals
signal podium_rose
signal start_game

#region Level Signals
signal level_1_load
signal level_1_instructions
signal level_1_completed

signal level_2_load
signal level_2_completed
signal wrong_book

signal level_3_load
signal level_3_completed
signal wrong_crystal

signal level_4_load
signal find_tool
signal spawn_staff_head
signal staff_head_connected
signal staff_forged
signal level_4_completed

signal level_5_load
signal button_pushed(color: String)
signal button_timeout
signal failed_simon
signal level_5_completed

signal level_6_load
signal reset_potions
signal level_6_completed

signal level_7_load
signal chest_opened
signal grabbed_hat
signal player_equipped_hat
signal level_7_completed

signal level_8_load
signal grow_potion_used
#endregion

signal show_credits
signal repeat_instructions
signal restart_level
signal reload_level
