var drop_area = instance_place(self.x, self.y, obj_card_drop_area);
if (instance_exists(drop_area) && instance_exists(drop_area.card)) {
    var dropped_card = drop_area.card.card_data;
}

if (drop_area != noone && drop_area.owner == "Player" && (drop_area.card == noone || drop_area.card == undefined)) {
    place_card(self, drop_area.x, drop_area.y);
    obj_hand.remove(self.id);
    // self.card_data.apply(obj_player, obj_player);
    if (instance_exists(self.dropped_area)) {
        self.dropped_area.card = noone;
        self.dropped_area = noone;
    }
    
    drop_area.card = self;
    self.dropped_area = drop_area;
    return;
}

var hand_area = instance_place(self.x, self.y, obj_hand);
if (hand_area != noone) {
    hand_area.add(self.id);
    if (instance_exists(self.dropped_area)) {
        self.dropped_area.card = noone;
        self.dropped_area = noone;
    }
}