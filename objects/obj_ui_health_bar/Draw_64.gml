if (room == rm_game_start) {
    exit;
}

var ratio = self.max_value > 0 ? self.current / self.max_value : 1;

draw_sprite_stretched(self.sprite_index, 0, 50, 600, 300 * ratio, 50);
draw_text_color(    
    375, 600, string(self.current) + "/" + string(self.max_value),
    c_black, c_black, c_black, c_black, 1
);