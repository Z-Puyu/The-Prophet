// Inherit the parent event
event_inherited();

loaded_map = ds_map_create();
loaded = [];
total_weight = 0;
read_row = function(r) {
    var card_id = self.read_cell(r, 0);
    var card_name = self.read_cell(r, 1);
    var card_type = self.read_cell(r, 2);
    var card_rarity = real(self.read_cell(r, 3));
    var card_damage = real(self.read_cell(r, 4));
    var card_heal_amount = real(self.read_cell(r, 5));
    var card_mark_id = self.read_cell(r, 6);
    var card_mark_multiplicity = real(self.read_cell(r, 7));
    var card_mark_id_to_remove = self.read_cell(r, 8);
    var card_mark_remove_count = real(self.read_cell(r, 9));
    var is_obtainable = bool(self.read_cell(r, 10));
    
    var sprite_name = $"spr_{card_id}";
    var sprite = asset_get_index(sprite_name);
    var card_data = new CardData(
        card_id, card_type, card_name, sprite, card_rarity,
        card_mark_id, card_mark_multiplicity, card_mark_id_to_remove, card_mark_remove_count,
        card_damage, card_heal_amount
    );
    
    ds_map_add(self.loaded_map, card_id, card_data);
    if (is_obtainable) {
        self.loaded[array_length(self.loaded)] = card_data;
        self.total_weight += (5 - card_rarity);
    }
    
    show_debug_message($"Loaded {card_id}: {card_data}");
}

/**
 * @desc Create a random card instance based on weighted probability.
 * @param {String|id.layer} instance_layer The instance layer's name or ID.
 * @param {real} pos_x The x-coordinate of the card's initial position. Default to -999.
 * @param {real} pos_y The y-coordinate of the card's initial position. Default to -999.
 **/
get_random_card = function(instance_layer, pos_x = -999, pos_y = -999) {
    var select = irandom_range(1, self.total_weight);
    var cumulative = 0;
    for (var i = 0; i < array_length(self.loaded); i += 1) {
        cumulative += self.loaded[i].get_weight();
        if (cumulative >= select) {
            return self.make_card(self.loaded[i], instance_layer, pos_x, pos_y);
        }
    }
    
    return self.make_card(array_last(self.loaded), instance_layer, pos_x, pos_y);
}

/**
 * @desc Create a random card instance based on weighted probability. The card can be clicked.\
 * This is mainly used to generate cards for deck selection or loot boxes.
 * @param {String|id.layer} instance_layer The instance layer's name or ID.
 * @param {real} pos_x The x-coordinate of the card's initial position. Default to -999.
 * @param {real} pos_y The y-coordinate of the card's initial position. Default to -999.
 **/
get_random_selectable_card = function(instance_layer, pos_x = -999, pos_y = -999) {
    var card = self.get_random_card(instance_layer, pos_x, pos_y);
    card.selectable = true;
    card.grabbable = false;
    return card;
}

/**
 * @desc Create a random card instance based on weighted probability. The card can be dragged and played.
 * This is mainly used to generate cards for battles.
 * @param {String|id.layer} instance_layer The instance layer's name or ID.
 * @param {real} pos_x The x-coordinate of the card's initial position. Default to -999.
 * @param {real} pos_y The y-coordinate of the card's initial position. Default to -999.
 **/
get_random_draggable_card = function(instance_layer, pos_x = -999, pos_y = -999) {
    var card = self.get_random_card(instance_layer, pos_x, pos_y);
    card.selectable = false;
    card.grabbable = true;
    return card;
}

/**
 * @desc Create a card instance using a card resource object.
 * @param {id.instance} resource_id The resource object ID. By convention it starts with "res_"
 * @param {String|id.layer} instance_layer The instance layer's name or ID.
 * @param {real} pos_x The x-coordinate of the card's initial position. Default to -999.
 * @param {real} pos_y The y-coordinate of the card's initial position. Default to -999.
 **/
make_card = function(resource_id, instance_layer, pos_x = -999, pos_y = -999) {
    var card_data = make_card_from(resource_id.object_index);
    var card = instance_create_layer(pos_x, pos_y, instance_layer, obj_card);
    card.card_data = card_data;
    return card;
}