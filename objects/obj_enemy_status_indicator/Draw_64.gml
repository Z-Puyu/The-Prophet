var text = "";
var key = ds_map_find_first(obj_enemy.data.marks);
while (key != undefined) {
    text += $"{res_loader_marks.loaded[? key].type}: {obj_enemy.data.marks[? key]}   ";
    key = ds_map_find_next(obj_enemy.data.marks, key);
}

key = ds_map_find_first(obj_enemy.data.status_effects);
while (key != undefined) {
    var status = obj_enemy.data.status_effects[? key];
    text += $"{status.name}: {status.level}   ";
    key = ds_map_find_next(obj_enemy.data.marks, key);
}

draw_set_halign(fa_center);
draw_text_color(    
    960, 75, text,
    c_black, c_black, c_black, c_black, 1
);
draw_set_halign(fa_left);