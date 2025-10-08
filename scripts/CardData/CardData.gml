/**
 * Function Description
 * @param {string} card_id Description
 * @param {string} card_type Description
 * @param {string} card_name Description
 * @param {Asset.GMSprite} card_sprite Description
 * @param {real} card_rarity Description
 * @param {string} mark_id Description
 * @param {real} mark_count description
 * @param {string} mark_id_to_remove Description
 * @param {real} mark_remove_count description
 * @param {real} attack_damage description    
 * @param {real} heal_amount description
 */
function CardData(
    card_id, card_type, card_name, card_sprite, card_rarity,
    mark_id, mark_count, mark_id_to_remove, mark_remove_count,
    attack_damage, heal_amount
) constructor {
    uid = card_id;
    type = card_type;
    name = card_name;
    sprite = card_sprite;
    rarity = card_rarity;
    mark = mark_id;
    mark_multiplicity = mark_count;
    mark_to_remove = mark_id_to_remove;
    mark_count_to_remove = mark_remove_count;
    damage = attack_damage;
    heal = heal_amount;
    
    /**
     * @desc Applies the card effects
     * @param {Struct.GameCharacterData} instigator The caster
     * @param {Struct.GameCharacterData} target The target
     */
    static apply = function(instigator, target) {
        // self.apply_reflexive_effects(instigator, target);
        switch(self.type) {
            case "Destruction":
                if (target == noone || target == undefined) {
                    show_debug_message("Attacked");   
                    return;     
                }
            
                var old_hp = target.hp;
                target.hp -= self.damage;
                target.hp = max(target.hp, 0);
                show_debug_message($"Attack {target}: HP {old_hp} -> {target.hp}");
                self.apply_marks(instigator, target); 
                break;
            case "Restoration":
                if (instigator == noone || instigator == undefined) {
                    show_debug_message("Healed");
                    return;        
                }
            
                var old_hp = instigator.hp;
                instigator.hp += self.heal;
                instigator.hp = min(instigator.max_hp, instigator.hp);
                show_debug_message($"Heal {instigator}: HP {old_hp} -> {instigator.hp}");
                self.apply_marks(instigator, instigator); 
                break;
            case "Alteration":
                if (instigator == noone || instigator == undefined) {
                    show_debug_message("Altered");
                    return;        
                }
            
                self.apply_marks(instigator, target);
                self.remove_marks(instigator, target);
                break; 
        }    
        
        
    }
    
    /**
     * @desc Applies any reflexive card effects
     * @param {id.instance} instigator The caster
     * @param {id.instance} target The target
     */
    static apply_reflexive_effects = function(instigator, target) {
        var old_hp = instigator.hp; 
        instigator.hp -= self.damage_to_self;
        show_debug_message($"{target}: HP {old_hp} -> {target.hp}");
    }
    
    static apply_marks = function(instigator, target) {
        var mark = res_loader_marks.loaded[? self.mark];
        mark.on_apply(target, mark_multiplicity);
    }
    
    static remove_marks = function(instigator, target) {
        target.add_marks(self.mark_to_remove, -self.mark_count_to_remove);
    }
    
    static describe = function(precision = 100) {
        var mark = res_loader_marks.loaded[? self.mark];
        var removed_mark = self.mark_to_remove == "none" ? noone : res_loader_marks.loaded[? self.mark_to_remove];
        var imprecision = 100 - precision;
        var p = irandom_range(100 - imprecision, 100 + imprecision) / 100.0;
        var knows_mark = irandom_range(1, 100) > imprecision;
        switch (self.type) {
        	case "Destruction":
                var predicted_damage = max(1, floor(self.damage * p));
                var predicted_damage_text = predicted_damage == self.damage ? string(self.damage) : $"{predicted_damage}?";
                var predicted_mark_count = max(1, floor(self.mark_multiplicity * p));
                var predicted_mark_count_text = predicted_mark_count == self.mark_multiplicity ? string(self.mark_multiplicity) : $"{predicted_mark_count}?";
                return knows_mark 
                    ? $"Deals {predicted_damage_text} {mark.type} damage\n" +
                      $"Target gains {predicted_mark_count_text} {mark.type} Mark"
                    : $"Deals {predicted_damage_text} damage";
            case "Restoration":
                var predicted_heal = max(0, floor(self.heal * p));
                var predicted_heal_text = predicted_heal == self.heal ? string(self.heal) : $"{predicted_heal}?";
                var predicted_mark_count = max(1, floor(self.mark_multiplicity * p));
                var predicted_mark_count_text = predicted_mark_count == self.mark_multiplicity ? string(self.mark_multiplicity) : $"{predicted_mark_count}?";
                var predicted_mark_remove_count = max(1, floor(self.mark_count_to_remove * p));
                var predicted_mark_remove_count_text = predicted_mark_remove_count == self.mark_count_to_remove ? string(self.mark_count_to_remove) : $"{predicted_mark_remove_count}?";
                var text = $"";
                if (predicted_heal > 0) {
                    text += $"Heals {predicted_heal_text} HP\n";
                }
            
                if (knows_mark) {
                    text += $"Caster gains {predicted_mark_count_text} {mark.type} Mark\n";
                }
            
                if (knows_mark && removed_mark != noone) {
                    text += $"Caster loses {predicted_mark_remove_count_text} {removed_mark.type} Mark";
                }
                
                return text;
            case "Alteration":
                var predicted_mark_count = max(1, floor(self.mark_multiplicity * p));
                var predicted_mark_count_text = predicted_mark_count == self.mark_multiplicity ? string(self.mark_multiplicity) : $"{predicted_mark_count}?";
                return knows_mark
                    ? $"Target gains {predicted_mark_count_text} {mark.type} Mark"
                    : $"Target gains Mark";
        }
    }
    
    static clone = function() {
        return new CardData(
            self.uid, self.type, self.name, self.sprite, self.rarity,
            self.mark, self.mark_multiplicity, self.mark_to_remove, self.mark_count_to_remove,
            self.damage, self.heal
        );
    }
}



