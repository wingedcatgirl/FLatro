SMODS.Atlas{
    key = "planet_placeholder",
    path = "planet_placeholder.png",
    px = 71,
    py = 95,
}

local newhands = {}

for k,v in pairs(SMODS.PokerHands) do
    if v.original_mod and v.original_mod.id == "marvellous" then
        newhands[#newhands+1] = v
    end
end

table.sort(newhands, function (a, b)
    local function eval(h)
        local own_amt = h.mult*h.chips
        if h.above_hand and SMODS.PokerHand.obj_table[h.above_hand] then
            local above_amt = eval(SMODS.PokerHand.obj_table[h.above_hand])
            return above_amt + (own_amt * 1e-6) + (h.order_offset or 0)
        end

        return own_amt + (h.order_offset or 0)
    end

    return eval(a) < eval(b)
end)

for i,v in ipairs(newhands) do
    SMODS.Consumable{
        set = 'Planet',
        cost = 3,
        unlocked = true,
        no_collection = not not SMODS.current_mod.version:find("~"),
        atlas = 'planet_placeholder',
        pos = { x = 0, y = 0 },
        key = v.key.."_planet",
        effect = 'Hand Upgrade',
        config = {hand_type = v.key, softlock = true},
        process_loc_text = function(self)
            --use another planet's loc txt instead
            local target_text = G.localization.descriptions[self.set]['c_mercury'].text
            SMODS.Consumable.process_loc_text(self)
            G.localization.descriptions[self.set][self.key] = G.localization.descriptions[self.set][self.key] or {}
            G.localization.descriptions[self.set][self.key].name = "#2# Planet Card"
            G.localization.descriptions[self.set][self.key].text = target_text
        end,
        set_card_type_badge = function(self, card, badges)
            badges[1] = create_badge("Planet?", get_type_colour(self or card.config, card), nil, 1.2)
        end,
        loc_vars = function(self, info_queue, card)
            local hand = card.ability.hand_type
            return {
                vars = {
                    G.GAME.hands[hand].level,
                    localize(hand, "poker_hands"),
                    G.GAME.hands[hand].l_mult,
                    G.GAME.hands[hand].l_chips,
                    colours = {
                        (
                            G.GAME.hands[hand].level == 1 and G.C.UI.TEXT_DARK
                            or G.C.HAND_LEVELS[math.min(7, G.GAME.hands[hand].level)]
                        ),
                    },
                },
            }
        end,
    }
end