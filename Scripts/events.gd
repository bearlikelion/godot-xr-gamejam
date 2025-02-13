@tool
extends Node

# Global signals
signal place_on_pedistal(scene_string: String)
signal podium_snapped(object_name: String)

# Star signals
signal podium_rose
signal start_game

#region Level Signals
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
signal level_5_completed
#endregion
