-- Two hands remain before the summit. They are, in their different ways, the most demanding constructions in the game.

SMODS.PokerHand{
    key = "Chain",
    chips = 230,
    mult = 20,
    above_hand = "marv_Bats",
    l_chips = 60,
    l_mult = 6,
    example = {
        { "S_3", true },
        { "S_4", true },
        { "C_5", true },
        { "C_6", true },
        { "D_7", true },
        { "D_8", true },
        { "H_9", true },
    },
    visible = function (self)
        return G.GAME.hands[self.key].played > 0 or MARV.config.see_all_hands_debug
    end,
    evaluate = function (parts, hand)
        if not MARV.is_marvellous() then  return {} end
        local chain = {}
        if #parts._straight >= 7 then
        for k,v in pairs(parts._straight) do
            chain[k] = v
        end
        else
            return {}
        end

        table.sort(chain, function (a, b)
            return a:get_id() > b:get_id()
        end)

        local seen_suits = {}
        local current_suit
        local current_flush = 0

        local length = 0
        for i,card in ipairs(chain) do
            length = i
            if SMODS.has_no_suit(card) then
                return {}
            elseif SMODS.has_any_suit then
                current_flush = current_flush + 1
                if current_flush > 2 then
                    current_flush = 1
                    current_suit = nil
                end
            else
                if not current_suit then
                    current_suit = card.base.suit
                    if seen_suits[current_suit] then break end
                    seen_suits[current_suit] = true
                    current_flush = current_flush + 1
                else
                    if card:is_suit(current_suit) then
                        current_flush = current_flush + 1
                        if current_flush > 2 then break end
                    else
                        if current_flush == 1 then
                            if i~=2 then break end
                        end
                        current_suit = card.base.suit
                        if seen_suits[current_suit] then break end
                        seen_suits[current_suit] = true
                        current_flush = 1
                    end
                end
            end
        end

        if length == #chain then return {chain} end
        while length >=7 and length < #chain do
            table.remove(chain)
        end

        table.sort(chain, function (a, b) --Flip it back and try again. sowwies but i am Not figuring out how to get a valid suit sequence in the middle of the chain; beginning and end only!
            return not a:get_id() > b:get_id()
        end)

        seen_suits = {}
        current_suit = nil
        current_flush = 0

        length = 0
        for i,card in ipairs(chain) do
            length = i
            if SMODS.has_no_suit(card) then
                return {}
            elseif SMODS.has_any_suit then
                current_flush = current_flush + 1
                if current_flush > 2 then
                    current_flush = 1
                    current_suit = nil
                end
            else
                if not current_suit then
                    current_suit = card.base.suit
                    if seen_suits[current_suit] then break end
                    seen_suits[current_suit] = true
                    current_flush = current_flush + 1
                else
                    if card:is_suit(current_suit) then
                        current_flush = current_flush + 1
                        if current_flush > 2 then break end
                    else
                        if current_flush == 1 then
                            if i~=2 then break end
                        end
                        current_suit = card.base.suit
                        if seen_suits[current_suit] then break end
                        seen_suits[current_suit] = true
                        current_flush = 1
                    end
                end
            end
        end

        while length >=7 and length < #chain do
            table.remove(chain)
        end

        return length >= 7 and {chain} or {}
    end
}

SMODS.PokerHand{
    key = "Ascension",
    chips = 234,
    mult = 23,
    above_hand = "marv_Chain",
    l_chips = 56,
    l_mult = 7,
    example = {
        { "S_2", true },
        { "S_3", true },
        { "S_4", true },
        { "S_5", true },
        { "S_6", true },
        { "S_7", true },
        { "S_8", true },
        { "S_9", true },
    },
    visible = function (self)
        return G.GAME.hands[self.key].played > 0 or MARV.config.see_all_hands_debug
    end,
    evaluate = function (parts, hand)
        if not MARV.is_marvellous() then  return {} end
        local ascension = {}
        local ranks = {}
        for i,card in ipairs(parts._flush) do
            local id = card:get_id()
            if id >= 2 and id <= 9 then
                ranks[id] = true
                ascension[#ascension+1] = card
            end
        end

        for i=2,9 do
            if not ranks[i] then return {} end
        end

        return {ascension}
    end
}