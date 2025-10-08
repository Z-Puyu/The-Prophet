if (room == rm_game_start) {
    draw_set_halign(fa_center);
    
    draw_text_transformed_color(960, 750, string(10 - obj_hand.size()), 3, 3, 0, c_black, c_black, c_black, c_black, 1);
    
    draw_set_valign(fa_left);
}