__private = {
    card_rarities: [],
    card_rarity_to_name: ds_map_create(),
    card_names_to_count: ds_map_create(),
    card_names_to_data: ds_map_create()
};

size = 0;

/// @desc Function Description
/// @param {id.instance} card_id Description
add = function(card_id) {
    var card_data = card_id.card_data;
    if (!ds_map_exists(self.__private.card_rarity_to_name, card_data.rarity)) {
        var idx = array_length(self.__private.card_rarities);
        self.__private.card_rarities[idx] = card_data.rarity;
        ds_map_add(self.__private.card_rarity_to_name, card_data.rarity, []);
    }
    
    if (!ds_map_exists(self.__private.card_names_to_count, card_data.name)) {
        ds_map_add(self.__private.card_names_to_count, card_data.name, 1);
        var idx = array_length(self.__private.card_rarity_to_name[? card_data.rarity]);
        self.__private.card_rarity_to_name[? card_data.rarity][idx] = card_data.name;
        ds_map_add(self.__private.card_names_to_data, card_data.name, card_data);
    } else {
        self.__private.card_names_to_count[? card_data.name] += 1;
    }
    
    size += 1;
}

/// @desc Function Description
/// @param {id.instance} card_id Description
remove = function(card_id) {
    var card_data = card_id.card_data;
    self.__private.card_names_to_count[? card_data.name] -= 1;
    if (self.__private.card_names_to_count[? card_data.name] == 0) {
        ds_map_delete(self.__private.card_names_to_data, card_data.name);
        ds_map_delete(self.__private.card_names_to_count, card_data.name);
        var idx = array_get_index(self.__private.card_rarity_to_name[? card_data.rarity], card_data.name);
        array_delete(self.__private.card_rarity_to_name[? card_data.rarity], idx, 1);
        if (array_length(self.__private.card_rarity_to_name[? card_data.rarity]) == 0) {
            ds_map_delete(self.__private.card_rarity_to_name, card_data.rarity);
            idx = array_get_index(self.__private.card_rarities, card_data.rarity);
            array_delete(self.__private.card_rarities, idx, 1);
        }
    }
    
    size -= 1;
}

/// @desc Denumerate the deck in ascending order of card rarity, and use alphabetical order of card names to break the tie
/// @returns {array<Struct.CardData>} Description
denumerate = function() {
    var a = [];
    var idx = 0;
    array_sort(self.__private.card_rarities, true);
    for (var i = 0; i < array_length(self.__private.card_rarities); i += 1) {
        var rarity = self.__private.card_rarities[i];
        var names = self.__private.card_rarity_to_name[? rarity];
        if (names == noone || names == undefined) {
            continue;
        }
        
        array_sort(names, function(left, right) {
            if (left < right) {
                return -1;
            } else if (left > right) {
                return 1;
            } else {
                return 0;
            }
        });
        
        for (var j = 0; j < array_length(names); j += 1) {
            var name = names[j];
            repeat (self.__private.card_names_to_count[? name]) {
            	a[idx] = self.__private.card_names_to_data[? name];
                idx += 1;
            }
        }
    }
    
    return a;
}

clear = function() {
    self.__private.card_rarities = [];
    ds_map_clear(self.__private.card_names_to_count);
    ds_map_clear(self.__private.card_names_to_data);
    ds_map_clear(self.__private.card_rarity_to_name);
    size = 0;
}