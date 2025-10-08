// Inherit the parent event
event_inherited();

played_cards = [];

play_card = function() {
    var idx = irandom_range(0, array_length(self.data.cards) - 1);
    var card_data = self.data.cards[idx];
    self.played_cards[array_length(self.played_cards)] = card_data;
    array_delete(self.data.cards, idx, 1);
    var card = instance_create_layer(self.x, -500, "Cards", obj_card);
    card.card_data = card_data;
    card.selectable = false;
    card.grabbable = false;
    var player = obj_battle_manager.player;
    var data = player.data;
    card.set_reveal(obj_battle_manager.player.data.get_revelation());
    return card;
}

reset_deck = function() {
    for (var i = 0; i < array_length(self.played_cards); i += 1) {
        self.data.cards[array_length(self.data.cards)] = self.played_cards[i];
    }
    
    self.played_cards = [];
}