--Above the Procedures, the hands become rare enough that seeing one at the table is worth remarking upon.

SMODS.PokerHand{
    key = "Wells",
    chips = 31,
    mult = 3,
    above_hand = "marv_Parliament",
    l_chips = 20,
    l_mult = 3,
    example = {
        { "S_2", true },
        { "C_2", true },
        { "D_A", true },
        { "S_K", false },
        { "H_K", true },
    },
    visible = function (self)
        return G.GAME.hands[self.key].played > 0 or MARV.config.see_all_hands_debug
    end,
    evaluate = function (parts, hand)
        if not G.GAME.marv_marvellous then return {} end
        local braces = 0
        local ace = false
        local cards = {}

        for i,v in ipairs(parts._2) do
            if v[1] and v[1]:get_id() == 14 then return {} end
            braces = braces + 1
            cards = SMODS.merge_lists(cards, v)
        end
        for i,v in ipairs(hand) do
            if v:get_id() == 14 then
                if ace then
                    return {} --This shouldn't happen; it'd have returned during the brace check
                else
                    ace = true
                    cards[#cards+1] = v
                end
            end
        end

        return braces >= 2 and ace and {cards} or {}
    end
}

SMODS.PokerHand{
    key = "Triumvirate",
    chips = 33,
    mult = 3,
    above_hand = "marv_Wells",
    l_chips = 30,
    l_mult = 3,
    example = {
        { "S_Q", true },
        { "H_7", false },
        { "D_K", true },
        { "S_3", false },
        { "H_J", true },
    },
    visible = function (self)
        return G.GAME.hands[self.key].played > 0 or MARV.config.see_all_hands_debug
    end,
    evaluate = function (parts, hand)
        if not G.GAME.marv_marvellous then return {} end
        local rankcheck = {
            jack = false,
            queen = false,
            king = false,
        }
        local suits = {
            Clubs = false,
            Diamonds = false,
            Hearts = false
        }
        local scoring = {}

        for _,card in ipairs(hand) do
            for suit in pairs(suits) do
                if card:is_suit(suit) then
                    local card_id = card:get_id()
                    local ranks = {[11] = "jack", [12] = "queen", [13] = "king"}
                    if ranks[card_id] and not suits[suit] and not rankcheck[ranks[card_id]] then
                        suits[suit] = true
                        rankcheck[ranks[card_id]] = true
                        scoring[#scoring+1] = card
                    else
                        return {}
                    end
                end
            end
        end
        local test = rankcheck.jack and rankcheck.queen and rankcheck.king and suits.Clubs and suits.Diamonds and suits.Hearts
        return test and {scoring} or {}
    end
}

SMODS.PokerHand{
    key = "Murder",
    chips = 50,
    mult = 7,
    above_hand = "marv_Triumvirate",
    l_chips = 30,
    l_mult = 7,
    example = {
        { "S_Q", true },
        { "C_Q", true },
        { "D_Q", true },
        { "S_K", false },
        { "H_Q", true },
    },
    visible = function (self)
        return G.GAME.hands[self.key].played > 0 or MARV.config.see_all_hands_debug
    end,
    evaluate = function (parts, hand)
        if not G.GAME.marv_marvellous then return {} end
        for _,v in ipairs(parts._4) do
            if v[1] and v[1]:get_id() == 12 then
                local cards = {}
                local suits = {}
                local suitcount = 0
                for __,card in ipairs(v) do
                    cards[#cards+1] = card
                    if SMODS.has_any_suit(card) then
                        suitcount = suitcount + 1
                    elseif not SMODS.has_no_suit(card) then
                        for k in pairs(SMODS.Suits) do
                            if not suits[k] and card:is_suit(k) then
                                suits[k] = true
                                suitcount = suitcount + 1
                            end
                        end
                    end
                end
                if suitcount >= 4 and #cards >= 4 then return {cards} end
            end
        end
        return {}
    end
}

SMODS.PokerHand{
    key = "Perfidy",
    chips = 51,
    mult = 7,
    above_hand = "marv_Murder",
    l_chips = 35,
    l_mult = 7,
    example = {
        { "S_Q", true },
        { "C_Q", true },
        { "D_Q", true },
        --Empty space, somehow?
        { "H_Q", true },
    },
    visible = function (self)
        return G.GAME.hands[self.key].played > 0 or MARV.config.see_all_hands_debug
    end,
    evaluate = function (parts, hand)
        if not G.GAME.marv_marvellous then return {} end
        return {} --Not possible until we invent the River
    end
}

--4oak -> Peace of Hell