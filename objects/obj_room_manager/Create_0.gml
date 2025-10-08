goto_battle = function() {
    if (room != rm_battle) {
        room_goto(rm_battle);
    }
}

goto_map = function() {
    if (room != Room1) {
        room_goto(Room1);
    }
}

goto_deck_selection = function() {
    if (room != rm_game_start) {
        room_goto(rm_game_start);
    }
}
