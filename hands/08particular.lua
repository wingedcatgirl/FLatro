--The hands that follow are rare enough that the Custodian has seen some of them only once or twice in all his years of keeping the game. He mentions this not to discourage you, but to prepare you for the particular quality of silence that falls over the table when one of them appears.

SMODS.PokerHand{
    key = "Mirrorcatch",
    chips = 90,
    mult = 9,
    above_hand = "Straight Flush",
    l_chips = 50,
    l_mult = 3,
    example = {
        { "S_7", true },
        { "S_8", true },
        { "S_9", true },
        { "H_7", true },
        { "H_8", true },
        { "H_9", true },
    },
    visible = function (self)
        return G.GAME.hands[self.key].played > 0 or MARV.config.see_all_hands_debug
    end,
    evaluate = function (parts, hand)
        if not G.GAME.marv_marvellous then return {} end
        local tracker = {}
        for _,string in ipairs(parts.marv_string) do
            tracker[#string] = tracker[#string] or {}
            tracker[#string][#tracker[#string]+1] = string
        end

        local longest, mirrorest = 0,0
        local strings = {}
        for k,v in pairs(tracker) do
            if mirrorest < #v or (mirrorest == #v and longest < k) then
                longest = k
                mirrorest = #v
                strings = v
            end
        end

        return mirrorest >= 2 and longest >= 3 and strings or {}
    end
}

SMODS.PokerHand{
    key = "Mirror",
    chips = 90,
    mult = 9,
    above_hand = "marv_Mirrorcatch",
    l_chips = 60,
    l_mult = 3,
    example = {
        { "C_9", true },
        { "H_K", true },
        { "C_T", true },
        { "D_K", true },
        { "C_8", true },
        { "C_7", true },
    },
    visible = function (self)
        return G.GAME.hands[self.key].played > 0 or MARV.config.see_all_hands_debug
    end,
    evaluate = function (parts, hand)
        if not G.GAME.marv_marvellous then return {} end
        local clubstring, kingbrace
        local cards = {}
        for _,string in ipairs(parts.marv_string) do
            if string[1] and string[1]:is_suit("Clubs") then
                clubstring = true
                cards = SMODS.merge_lists(cards, string)
            end
        end
        for _,brace in ipairs(parts._2) do
            if brace[1] and brace[1]:get_id() == 13 then
                kingbrace = true
                cards = SMODS.merge_lists(cards, brace)
            end
        end
        return clubstring and kingbrace and {cards} or {}
    end
}

SMODS.PokerHand{
    key = "Doctrine",
    chips = 97,
    mult = 9,
    above_hand = "marv_Mirror",
    l_chips = 31,
    l_mult = 5,
    example = {
        { "H_A", true },
        { "H_3", true },
        { "H_5", true },
        { "H_7", true },
        { "H_9", true },
    },
    visible = function (self)
        return G.GAME.hands[self.key].played > 0 or MARV.config.see_all_hands_debug
    end,
    evaluate = function (parts, hand)
        if not G.GAME.marv_marvellous then return {} end
        local ret = {}
        for _,v in ipairs(parts._flush) do
            local cards = {}
            local ranks = {
                [3] = false,
                [5] = false,
                [7] = false,
                [9] = false,
                [14] = false
            }
            for __,card in ipairs(v) do
                local id = card:get_id()
                if ranks[id] ~= nil then
                    ranks[id] = true
                    cards[#cards+1] = card
                end
            end

            local check = true
            for _,val in pairs(ranks) do
                if not val then check = false break end
            end

            if check then ret[#ret+1] = cards end
        end

        return ret
    end
}

SMODS.PokerHand{
    key = "Bats",
    chips = 111,
    mult = 11,
    above_hand = "marv_Doctrine",
    l_chips = 33,
    l_mult = 3,
    example = {
        { "C_4", true },
        { "H_5", true },
        { "D_6", true },
        { "S_7", true },
        { "C_8", true },
    },
    visible = function (self)
        return G.GAME.hands[self.key].played > 0 or MARV.config.see_all_hands_debug
    end,
    evaluate = function (parts, hand)
        if not G.GAME.marv_marvellous then return {} end
        local flight = {}
        for k,v in pairs(parts._straight) do
            flight[k] = v
        end
        
        table.sort(flight, function (a, b)
            return a:get_id() > b:get_id()
        end)

        local suits = {
            Spades = false,
            Hearts = false,
            Diamonds = false
        }
        local wilds = 0

        for i,card in ipairs(flight) do
            if i==1 or i==#flight then
                if not card:is_suit("Clubs") then return {} end
            elseif SMODS.has_any_suit(card) then
                wilds = wilds + 1
            elseif not SMODS.has_no_suit(card) then
                for suit in pairs(suits) do
                    if card:is_suit(suit) then
                        if suits[suit] then return {} end
                        suits[suit] = true
                    end
                end
            end
        end

        for _,v in pairs(suits) do
            if not v then
                if wilds > 1 then
                    wilds = wilds - 1
                else
                    return {}
                end
            end
        end
        return {flight}
    end
}