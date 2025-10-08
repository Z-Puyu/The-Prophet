if (!self.is_during_player_turn) {
    exit;
}

self.is_during_player_turn = false;
self.end_player_turn();