if (self.hovered) {
	// Draw a stroke around the card.
	draw_sprite_ext(spr_card_stroke_with_blur, 0, self.x + 1, self.y + 2, self.image_xscale, self.image_xscale, image_angle, c_white, 0.5);
    self.current_depth -= 10000;
} else {
    self.current_depth = normal_depth;
}

self.depth = self.current_depth;
draw_self();
if (self.card_data != undefined && self.should_reveal) {
    if (self.reveal >= 100) {
        draw_sprite(self.card_data.sprite, self.image_index, self.x, self.y);
    }
    
    var x_padding = 25 * self.image_xscale;
    var y_padding = 25 * self.image_xscale;
    var text_x = self.x - self.sprite_width / 2 + x_padding;
    var text_y = self.y - self.sprite_height / 2 + y_padding;
    
    draw_set_halign(fa_center);
    
    draw_text_ext_transformed_color(
        self.x, text_y, self.card_data.name, 
        20, self.sprite_width - 2 * x_padding,
        self.image_xscale, self.image_yscale, self.image_angle,
        c_black, c_black, c_black, c_black, 1
    );
    
    draw_set_halign(fa_left);
    
    text_y += y_padding;
    draw_text_ext_transformed_color(
        text_x, text_y, self.desc, 
        20, self.sprite_width - 2 * x_padding,
        self.image_xscale, self.image_yscale, self.image_angle,
        c_black, c_black, c_black, c_black, 1
    );   
} 
