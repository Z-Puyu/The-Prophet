var text = "";
var key = ds_map_find_first(obj_player_state.data.marks);
while (key != undefined) {
    text += $"{res_loader_marks.loaded[? key].type}: {obj_player_state.data.marks[? key]}   ";
    key = ds_map_find_next(obj_player_state.data.marks, key);
}

key = ds_map_find_first(obj_player_state.data.status_effects);
while (key != undefined) {
    var status = obj_player_state.data.status_effects[? key];
    text += $"{status.name}: {status.level}   ";
    key = ds_map_find_next(obj_player_state.data.marks, key);
}

draw_set_halign(fa_center);
draw_text_color(    
    960, 850, text,
    c_black, c_black, c_black, c_black, 1
);
draw_set_halign(fa_left);