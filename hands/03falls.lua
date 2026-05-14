local function check_id(card)
    if type(card) == "table" and card.get_id then return card:get_id() end
end

local function get_lowest_card_from_hand(hand)
    local lowest_card
        
    for i,card in ipairs(hand) do
        if not SMODS.has_no_rank(card) then
            if not lowest_card then
                lowest_card = card
            else
                local lowest_id, current_id = (check_id(lowest_card) or math.huge), card:get_id()
                if lowest_id == 14 then lowest_id = 1 end
                if current_id == 14 then current_id = 1 end

                if current_id < lowest_id then
                    lowest_card = card
                end
            end
        end
    end

    return lowest_card
end

local function get_part_with_lowest_card(parts)
    local lowest_card, lowest_hand
    for _,hand in ipairs(parts) do
        local lowest_in_hand = get_lowest_card_from_hand(hand)
        if not lowest_in_hand then return {} end
        if not lowest_card then
            lowest_card = lowest_in_hand
            lowest_hand = hand
        else
            local lowest_id, current_id = (check_id(lowest_card) or math.huge), lowest_in_hand:get_id()
            if lowest_id == 14 then lowest_id = 1 end
            if current_id == 14 then current_id = 1 end
            if current_id < lowest_id then
                lowest_card = lowest_in_hand
                lowest_hand = hand
            elseif current_id == lowest_id then
                if #hand > #lowest_hand then
                    lowest_card = lowest_in_hand
                    lowest_hand = hand
                end
            end
        end

    end

    return lowest_hand or {}, lowest_card
end

SMODS.PokerHandPart{
    key = "fall",
    func = function (hand)
        local runs = get_straight(hand, 3, false, false)
        if not next(runs) then return {} end
        local falls = {}
        for i,run in ipairs(runs) do
            local city = get_lowest_card_from_hand(run)
            if city:get_id() == 14 or city:get_id() <= 7 then
                falls[#falls+1] = run
            end
        end

        return falls
    end
}

SMODS.PokerHand{
    key = "Fall7",
    chips = 75,
    mult = 1,
    --order_offset = 0.01,
    above_hand = "marv_Retreat",
    l_chips = 15,
    l_mult = 2,
    example = {
        { "S_A", false },
        { "C_9", true },
        { "C_7", true },
        { "S_8", true },
        { "H_3", false },
    },
    visible = function (self)
        return G.GAME.hands[self.key].played > 0 or MARV.config.see_all_hands_debug
    end,
    evaluate = function (parts, hand)
        if not G.GAME.marv_marvellous then return {} end
        local fall, city = get_part_with_lowest_card(parts.marv_fall)
        if not next(fall) or not city then return {} end

        return city:get_id() == 7 and {fall} or {}
    end
}

SMODS.PokerHand{
    key = "Fall6",
    chips = 75,
    mult = 1,
    --order_offset = 0.02,
    above_hand = "marv_Fall7",
    l_chips = 15,
    l_mult = 2,
    example = {
        { "S_6", true },
        { "C_Q", false },
        { "D_7", true },
        { "S_8", true },
        { "H_3", false },
    },
    visible = function (self)
        return G.GAME.hands[self.key].played > 0 or MARV.config.see_all_hands_debug
    end,
    evaluate = function (parts, hand)
        if not G.GAME.marv_marvellous then return {} end
        local fall, city = get_part_with_lowest_card(parts.marv_fall)
        if not next(fall) or not city then return {} end

        return city:get_id() == 6 and {fall} or {}
    end
}

SMODS.PokerHand{
    key = "Fall5",
    chips = 75,
    mult = 1,
    above_hand = "marv_Fall6",
    --order_offset = 0.03,
    l_chips = 15,
    l_mult = 2,
    example = {
        { "S_6", true },
        { "C_9", false },
        { "D_5", true },
        { "S_A", false },
        { "D_7", true },
    },
    visible = function (self)
        return G.GAME.hands[self.key].played > 0 or MARV.config.see_all_hands_debug
    end,
    evaluate = function (parts, hand)
        if not G.GAME.marv_marvellous then return {} end
        local fall, city = get_part_with_lowest_card(parts.marv_fall)
        if not next(fall) or not city then return {} end

        return city:get_id() == 5 and {fall} or {}
    end
}

SMODS.PokerHand{
    key = "Fall4",
    chips = 38,
    mult = 2,
    above_hand = "marv_Fall5",
    --order_offset = 0.04,
    l_chips = 15,
    l_mult = 2,
    example = {
        { "S_4", true },
        { "C_9", false },
        { "D_5", true },
        { "S_8", false },
        { "S_6", true },
    },
    visible = function (self)
        return G.GAME.hands[self.key].played > 0 or MARV.config.see_all_hands_debug
    end,
    evaluate = function (parts, hand)
        if not G.GAME.marv_marvellous then return {} end
        local fall, city = get_part_with_lowest_card(parts.marv_fall)
        if not next(fall) or not city then return {} end

        return city:get_id() == 4 and {fall} or {}
    end
}

SMODS.PokerHand{
    key = "Fall3",
    chips = 26,
    mult = 3,
    above_hand = "marv_Fall4",
    --order_offset = 0.05,
    l_chips = 15,
    l_mult = 2,
    example = {
        { "C_4", true },
        { "C_5", true },
        { "D_Q", false },
        { "S_A", false },
        { "H_3", true },
    },
    visible = function (self)
        return G.GAME.hands[self.key].played > 0 or MARV.config.see_all_hands_debug
    end,
    evaluate = function (parts, hand)
        if not G.GAME.marv_marvellous then return {} end
        local fall, city = get_part_with_lowest_card(parts.marv_fall)
        if not next(fall) or not city then return {} end

        return city:get_id() == 3 and {fall} or {}
    end
}

SMODS.PokerHand{
    key = "Fall2",
    chips = 20,
    mult = 4,
    above_hand = "marv_Fall3",
    --order_offset = 0.06,
    l_chips = 15,
    l_mult = 2,
    example = {
        { "H_4", true },
        { "C_2", true },
        { "D_Q", false },
        { "S_6", false },
        { "H_3", true },
    },
    visible = function (self)
        return G.GAME.hands[self.key].played > 0 or MARV.config.see_all_hands_debug
    end,
    evaluate = function (parts, hand)
        if not G.GAME.marv_marvellous then return {} end
        local fall, city = get_part_with_lowest_card(parts.marv_fall)
        if not next(fall) or not city then return {} end

        return city:get_id() == 2 and {fall} or {}
    end
}

SMODS.PokerHand{
    key = "Fall1",
    chips = 17,
    mult = 5,
    above_hand = "marv_Fall2",
    --order_offset = 0.07,
    l_chips = 15,
    l_mult = 2,
    example = {
        { "S_A", true },
        { "S_2", true },
        { "D_Q", false },
        { "S_6", false },
        { "H_3", true },
    },
    visible = function (self)
        return G.GAME.hands[self.key].played > 0 or MARV.config.see_all_hands_debug
    end,
    evaluate = function (parts, hand)
        if not G.GAME.marv_marvellous then return {} end
        local fall, city = get_part_with_lowest_card(parts.marv_fall)
        if not next(fall) or not city then return {} end

        return city:get_id() == 14 and {fall} or {}
    end
}