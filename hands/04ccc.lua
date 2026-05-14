SMODS.PokerHand{
    key = "Crisis",
    chips = 25,
    mult = 3,
    above_hand = "marv_Fall1",
    l_chips = 10,
    l_mult = 2,
    example = {
        { "S_3", true },
        { "D_4", true },
        { "H_5", true },
        { "D_A", false },
        { "H_9", false },
    },
    visible = function (self)
        return G.GAME.hands[self.key].played > 0 or MARV.config.see_all_hands_debug
    end,
    evaluate = function (parts, hand)
        if not MARV.is_marvellous() then  return {} end
        local runs = get_straight(hand, 3, false, false)
        if not next(runs) then return {} end
        local crisis = {}
        for _,run in ipairs(runs) do
            local suits = {

            }
            for i,card in ipairs(run) do
                if SMODS.has_no_suit(card) then
                    if suits["None"] then goto nvm end
                    suits["None"] = true
                elseif not SMODS.has_any_suit(card) and not suits[card.base.suit] then
                    suits[card.base.suit] = true
                elseif not SMODS.has_any_suit(card) then
                    goto nvm
                end
            end
            crisis[#crisis+1] = run
            ::nvm::
        end

        return crisis
    end
}

SMODS.PokerHand{
    key = "Collusion",
    chips = 17,
    mult = 5,
    above_hand = "marv_Crisis",
    --order_offset = 0.08,
    l_chips = 10,
    l_mult = 2,
    example = {
        { "H_3", true },
        { "D_4", true },
        { "C_3", true },
        { "H_T", true },
    },
    visible = function (self)
        return G.GAME.hands[self.key].played > 0 or MARV.config.see_all_hands_debug
    end,
    evaluate = function (parts, hand)
        if not MARV.is_marvellous() then  return {} end
        --TODO, add blackjack rule for Aces?
        local count, total = 0,0
        local highest
        for i,card in ipairs(hand) do
            if not SMODS.has_no_rank(card) then
                count = count + 1
                highest = (highest and highest.base.nominal or 0) > card.base.nominal and highest or card
                total = total + card.base.nominal
            end
        end

        if count ~= 4 then return {} end
        if highest.base.nominal*2 == count then return {hand} end
        return {}
    end
}

SMODS.PokerHand{
    key = "Crowns",
    chips = 40,
    mult = 4,
    above_hand = "marv_Collusion",
    l_chips = 10,
    l_mult = 1,
    example = {
        { "S_K", true },
        { "H_K", true },
        { "H_Q", true },
        { "C_Q", true },
        { "D_2", false },
    },
    visible = function (self)
        return G.GAME.hands[self.key].played > 0 or MARV.config.see_all_hands_debug
    end,
    evaluate = function (parts, hand)
        if not MARV.is_marvellous() then  return {} end
        local result = {}
        local king, queen = false, false
        for i,v in ipairs(parts._2) do
            if v[1] and v[1]:get_id() == SMODS.Ranks.King.id then
                king = true
                result[#result+1] = v
            end
            if v[1] and v[1]:get_id() == SMODS.Ranks.Queen.id then
                queen = true
                result[#result+1] = v
            end
        end
        return king and queen and result or {}
    end
}

