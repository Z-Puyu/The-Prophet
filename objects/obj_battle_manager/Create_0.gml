enemy = undefined;
player = obj_player_state;

draw_pile = obj_draw_pile;
discard_pile = obj_discard_pile;
deck = obj_card_pile;
hand = obj_hand;

enemy_card_slots = [];
player_card_slots = [];

max_turn_pointer = 0;
turn_pointer = 0; 
can_resolve_card = false;
is_during_player_turn = false;
enemy_cards = []; 
player_cards = [];

turn_timer = undefined;

resolve_turn = function() { 
    self.can_resolve_card = false;
    self.turn_pointer = 0;
    self.max_turn_pointer = 0;
    self.enemy_cards = [];
    self.player_cards = [];
    transfer_between_piles(self.hand, self.discard_pile, 0, false);
    if (self.player.data.hp <= 0) {
        self.enemy_win();
    } else if (self.enemy.data.hp <= 0) {
        self.player_win();
    } else {
        self.start_player_turn();
    }
}

enemy_win = function() {
    obj_player_deck_manager.clear();
    obj_room_manager.goto_deck_selection();
}

player_win = function() {
    self.player.data.vision += 1;
    self.end_battle();
    obj_room_manager.goto_map();
}

start_battle = function() {
    obj_player_state.data.clear_marks_and_statuses();
    var n = instance_number(obj_card_drop_area);
    for (var i = 0; i < n; i += 1) {
        var drop_area = instance_find(obj_card_drop_area, i);
        switch (drop_area.owner) {
        	case "Player":
                self.player_card_slots[array_length(self.player_card_slots)] = drop_area;
                break;
            case "Enemy":
                self.enemy_card_slots[array_length(self.enemy_card_slots)] = drop_area;
                break;
        }
    }
    
    transfer_between_piles(self.deck, self.draw_pile, 0, false);
    self.draw_pile.shuffle();
    //var ac_channel = animcurve_get_channel(ac_enemy_weight_distance_coefficient, "coefficient");
    //var k = animcurve_channel_evaluate(ac_channel, )
    self.enemy = res_loader_enemies.get_random_enemy("Characters", room_width / 2, 0);
    self.enemy.data.clear_marks_and_statuses();
    self.start_player_turn();
}

start_player_turn = function() {
    self.enemy.reset_deck();
    self.is_during_player_turn = true;
    for (var i = 0; i < array_length(self.player_card_slots); i += 1) {
        if (instance_exists(self.player_card_slots[i].card)) {
            self.player_card_slots[i].card.dropped_area = noone;
        }
        
        self.player_card_slots[i].card = noone;
    }
    
    for (var i = 0; i < array_length(self.enemy_card_slots); i += 1) {
        var card = self.enemy.play_card();
        card.image_xscale = self.enemy_card_slots[i].image_xscale;
        card.image_yscale = self.enemy_card_slots[i].image_yscale;
        place_card(card, self.enemy_card_slots[i].x, self.enemy_card_slots[i].y);
        enemy_card_slots[i].card = card;
    }
    
    repeat(5) {
        var card = self.draw();
        if (card == noone) {
            break;
        }
        
        card.set_reveal(100);
        card.grabbable = true;
        self.hand.add(card.id);
    }
}

draw = function() {
    if (self.draw_pile.is_empty()) {
        transfer_between_piles(self.discard_pile, self.draw_pile, 0, false);
        self.draw_pile.shuffle();
    }
    
    return self.draw_pile.draw();
}

execute_player_card = function(card) {
    card.card_data.apply(self.player.data, self.enemy.data);
    time_source_destroy(self.turn_timer);
    self.turn_timer = time_source_create(
        time_source_game, 0.1, time_source_units_seconds, 
        recycle_player_card, [card]
    );
    
    time_source_start(self.turn_timer);
}
    
execute_enemy_card = function(card) {
    card.set_reveal(100);
    var card_data = card.card_data;
    card_data.apply(self.enemy.data, self.player.data);
    time_source_destroy(self.turn_timer);
    self.turn_timer = time_source_create(
        time_source_game, 0.1, time_source_units_seconds, 
        recycle_enemy_card, [card]
    );
    
    time_source_start(self.turn_timer);
}
    
recycle_player_card = function(card) { 
    time_source_destroy(self.turn_timer);
    if (card != noone) {
        self.discard_pile.add(card);
        card.grabbable = false; 
        card.set_reveal(0);
    }
    
    if (self.enemy.data.hp <= 0 || self.player.data.hp <= 0) {
        self.resolve_turn();
        return;
    }
    
    self.turn_pointer += 1;
    if (self.turn_pointer == self.max_turn_pointer) {
        self.resolve_turn();
    } else {
        self.can_resolve_card = true;
    }
}
    
recycle_enemy_card = function(card) { 
    time_source_destroy(self.turn_timer);
    if (card != noone) { 
        place_card(card, self.enemy.x, -500);
        instance_destroy(card);
    }
    
    if (self.enemy.data.hp <= 0 || self.player.data.hp <= 0) {
        self.resolve_turn();
        return;
    }
    
    self.turn_pointer += 1;
    if (self.turn_pointer == self.max_turn_pointer) {
        self.resolve_turn();
    } else {
        self.can_resolve_card = true;
    }
}

end_player_turn = function() {
    self.player.data.execute_status_effects();
    if (self.player.data.hp <= 0) {
        self.resolve_turn();
        return;
    }
    
    self.enemy.data.execute_status_effects();
    if (self.enemy.data.hp <= 0) {
        self.resolve_turn();
        return;
    }
    
    self.turn_pointer = 0;
    // Collect both sides' cards
    for (var i = 0; i < array_length(self.player_card_slots); i += 1) {
        self.player_cards[i] = self.player_card_slots[i].card;
    }
    
    for (var i = 0; i < array_length(self.enemy_card_slots); i += 1) {
        self.enemy_cards[i] = self.enemy_card_slots[i].card;
    }
    
    self.max_turn_pointer = max(array_length(self.player_cards), array_length(self.enemy_cards)) * 2;
    self.can_resolve_card = true;
}

end_battle = function() {
    self.player_card_slots = [];
    self.enemy_card_slots = [];
    self.can_resolve_card = false;
    self.turn_pointer = 0;
    self.max_turn_pointer = 0;
    self.enemy_cards = [];
    self.player_cards = [];
    transfer_between_piles(self.hand, self.discard_pile, 0, false);
}