SMODS.PokerHand{
    key = "All_manner",
    chips = 777,
    mult = 77,
    above_hand = "marv_Ascension",
    l_chips = 77,
    l_mult = 7,
    example = {
        { "C_7", true },
        { "S_7", true },
        { "D_7", true },
        { "H_7", true },
    },
    visible = function (self)
        return G.GAME.hands[self.key].played > 0 or MARV.config.see_all_hands_debug
    end,
    evaluate = function (parts, hand)
        if not G.GAME.marv_marvellous then return {} end
        for _,set in ipairs(parts._4) do
            if set[1]:get_id() == 7 then
                local suits = {
                }
                local wilds = 0

                for i,card in ipairs(set) do
                    if SMODS.has_any_suit(card) then
                        wilds = wilds + 1
                    elseif not SMODS.has_no_suit(card) then
                        for suit in pairs(SMODS.Suits) do
                            if card:is_suit(suit) then
                                suits[suit] = true
                                break
                            end
                        end
                    end
                end

                for _,v in pairs(SMODS.suits) do
                    if not suits[v] then
                        if wilds > 1 then
                            wilds = wilds - 1
                        else
                            return {}
                        end
                    end
                end

                return {set}
            end
        end

        return {}
    end
}