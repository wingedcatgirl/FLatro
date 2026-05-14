SMODS.PokerHand{
    key = "Tragedy",
    chips = 33,
    mult = 3,
    above_hand = "Flush",
    l_chips = 13,
    l_mult = 3,
    example = {
        { "H_6", true },
        { "C_7", true },
        { "H_8", true },
        { "H_9", true },
        { "C_3", false },
    },
    visible = function (self)
        return G.GAME.hands[self.key].played > 0 or MARV.config.see_all_hands_debug
    end,
    evaluate = function (parts, hand)
        if not MARV.is_marvellous() then  return {} end
        local runs = get_straight(hand, 4, SMODS.shortcut(), SMODS.wrap_around_straight())
        if not next(runs) then return {} end
        local tragedy = {}

        for i,run in ipairs(runs) do
            if not next(run) then goto nvm end
            local suits = {}
            local wilds = 0
            local tragic, procedure = false, false
            for _,card in ipairs(run) do
                if not SMODS.has_any_suit(card) then
                    if SMODS.has_no_suit(card) then
                        suits["none"] = suits["none"] or {}
                        suits["none"][#suits["none"]+1] = card
                    else
                        for k in pairs(SMODS.Suits) do
                            suits[k] = suits[k] or {}
                            if card:is_suit(k) then
                                suits[k][#suits[k]+1] = card
                            end
                        end
                    end
                else
                    wilds = wilds + 1
                end
            end
            for suit,cards in pairs(suits) do
                if #cards + wilds == #run - 1 and suit ~= "none" then
                    procedure = true
                elseif #cards == 1 then
                    tragic = true
                end
            end
            if tragic and procedure then
                tragedy[#tragedy+1] = run
            end
            ::nvm::
        end
        
        return tragedy
    end
}

SMODS.PokerHand{
    key = "Procedure",
    chips = 33,
    mult = 3,
    above_hand = "marv_Tragedy",
    l_chips = 13,
    l_mult = 3,
    example = {
        { "H_6", true },
        { "H_7", true },
        { "H_8", true },
        { "H_9", true },
        { "C_3", false },
    },
    visible = function (self)
        return G.GAME.hands[self.key].played > 0 or MARV.config.see_all_hands_debug
    end,
    evaluate = function (parts, hand)
        if not MARV.is_marvellous() then  return {} end
        local procedures = {}
        for i,v in ipairs(parts._flush) do
            local runs = get_straight(v, 4, SMODS.shortcut(), SMODS.wrap_around_straight())
            if next(runs) then procedures = SMODS.merge_lists(procedures, runs) end
        end
        return next(procedures) and procedures or {}
    end
}

SMODS.PokerHand{
    key = "Parliament",
    chips = 40,
    mult = 3,
    above_hand = "marv_Procedure",
    l_chips = 30,
    l_mult = 4,
    example = {
        { "D_6", false },
        { "H_J", true },
        { "H_Q", true },
        { "H_K", true },
        { "C_3", false },
    },
    visible = function (self)
        return G.GAME.hands[self.key].played > 0 or MARV.config.see_all_hands_debug
    end,
    evaluate = function (parts, hand)
        if not MARV.is_marvellous() then  return {} end
        local parliaments = {}
        for _,v in ipairs(parts._flush) do
            local king, queen, jack
            local cards = {}
            for __,card in ipairs(v) do
                local id = card:get_id()
                if id == 11 then
                    jack = true
                    cards[#cards+1] = card
                elseif id == 12 then
                    queen = true
                    cards[#cards+1] = card
                elseif id == 13 then
                    king = true
                    cards[#cards+1] = card
                end
            end
            if king and queen and jack then
                parliaments[#parliaments+1] = cards
            end
        end

        return parliaments
    end
}