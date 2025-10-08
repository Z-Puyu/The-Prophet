if (room == rm_game_start) {
    global.new_game = true;
    show_debug_message("Game Started");
    var cards = obj_hand.clear();
    for (var i = 0; i < array_length(cards); i += 1) {
        obj_player_deck_manager.add(cards[i]);
    }
    
    obj_room_manager.goto_map();
}