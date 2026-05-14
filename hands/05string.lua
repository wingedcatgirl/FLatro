SMODS.PokerHandPart{
    key = "string",
    func = function (hand)
        local suits = {}
        local tracker = {}
        local strings = {}
        for _,card in ipairs(hand) do
            for suit in pairs(SMODS.Suits) do
                if card:is_suit(suit) and not (tracker[suit] and tracker[suit][card]) then
                    suits[suit] = suits[suit] or {}
                    suits[suit][#suits[suit]+1] = card
                    tracker[suit] = tracker[suit] or {}
                    tracker[suit][card] = true
                end
            end
        end
        for _,cards in pairs(suits) do
            local runs = get_straight(cards, 3, SMODS.shortcut(), SMODS.wrap_around_straight())
            if not next(runs) then return {} end
            for i,run in ipairs(runs) do
                if next(run) then strings[#strings+1] = run end
            end

        end

        return strings
    end
}

SMODS.PokerHand{
    key = "String",
    chips = 30,
    mult = 3,
    above_hand = "marv_Crowns",
    l_chips = 15,
    l_mult = 2,
    example = {
        { "S_5", true },
        { "S_7", true },
        { "S_6", true },
        { "S_8", true },
        { "H_3", false },
    },
    visible = function (self)
        return G.GAME.hands[self.key].played > 0 or MARV.config.see_all_hands_debug
    end,
    evaluate = function (parts, hand)
        if not G.GAME.marv_marvellous then return {} end
        return parts.marv_string
    end
}