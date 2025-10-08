// Inherit the parent event
event_inherited();

on_click = function() {
    obj_battle_manager.end_battle();
    obj_room_manager.goto_map();
}