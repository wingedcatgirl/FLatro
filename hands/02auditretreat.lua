SMODS.PokerHand{
    key = "Audit",
    chips = 25,
    mult = 3,
    above_hand = "marv_Polythremian",
    l_chips = 15,
    l_mult = 3,
    example = {
        { "S_3", true },
        { "C_7", true },
        { "D_T", true },
        { "S_K", false },
        { "H_3", true },
    },
    visible = function (self)
        return G.GAME.hands[self.key].played > 0 or MARV.config.see_all_hands_debug
    end,
    evaluate = function (parts, hand)
        if not G.GAME.marv_marvellous then return {} end
        local cards = {}
        local suits = {}
        local count = 0
        for _,card in ipairs(hand) do
            if not card:is_face() and not SMODS.has_no_suit(card) then
                if SMODS.has_any_suit(card) then
                    cards[#cards+1] = card
                    count = count + 1
                else
                    for k,v in pairs(SMODS.Suits) do
                        if card:is_suit(k) then
                            if not suits[k] then
                                suits[k] = true
                                count = count + 1
                                break
                            end
                        end
                    end
                    cards[#cards+1] = card
                end
            end
        end
        if count >= 4 then return {cards} else return {} end
    end
}

SMODS.PokerHand{
    key = "Retreat",
    chips = 25,
    mult = 3,
    above_hand = "marv_Audit",
    l_chips = 10,
    l_mult = 3,
    example = {
        { "S_9", true },
        { "D_8", false },
        { "S_T", true },
        { "C_3", false },
        { "S_J", true },
    },
    visible = function (self)
        return G.GAME.hands[self.key].played > 0 or MARV.config.see_all_hands_debug
    end,
    evaluate = function (parts, hand)
        if not G.GAME.marv_marvellous then return {} end
        local res = {}
        local runs = get_straight(hand, 3, SMODS.shortcut())
        if not next(runs) then return {} end
        for _,run in ipairs(runs) do
            local faces, nonfaces = 0,0
            for __,v in ipairs(run) do
                if v:is_face() then faces = faces + 1 else nonfaces = nonfaces + 1 end
            end
            if faces == 1 and nonfaces >= 2 then res[#res+1] = run end
        end
        return res
    end
}