@tool
extends Node

# Global signals
signal place_on_pedistal(scene_string: String)
signal podium_snapped(object_name: String)

# Star signals
signal podium_rose
signal start_game

# Level Signals
signal level_1_completed

signal level_2_load
signal level_2_completed
signal wrong_book

signal level_3_load
signal level_3_completed
signal wrong_crystal

signal level_4_load
signal level_4_completed
signal crystal_on_anvil
signal spawn_staff_head
signal crystal_attached
signal staff_burned
