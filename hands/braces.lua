SMODS.PokerHand{
    key = "Stone_pig",
    chips = 20,
    mult = 2,
    l_chips = 15,
    l_mult = 2,
    example = {
        { "S_3", true },
        { "D_4", true },
        { "C_3", true },
        { "C_7", false },
        { "S_4", true },
    },
    evaluate = function (parts, hand)
        local result = {}
        local four, threefive = false, false
        for i,v in ipairs(parts) do
            if v[1]:get_id() == 4 then
                four = true
                result[#result+1] = v
            end
            if v[1]:get_id() == 3 or v[1]:get_id() == 5 then
                threefive = true
                result[#result+1] = v
            end
        end
        return four and threefive and result or {}
    end
}

SMODS.PokerHand{
    key = "Remorse",
    chips = 15,
    mult = 3,
    l_chips = 10,
    l_mult = 3,
    example = {
        { "S_3", false },
        { "D_2", true },
        { "C_Q", true },
        { "C_7", false },
        { "S_Q", true },
    },
    evaluate = function (parts, hand)
        local result = {}
        local queen, two = false, false
        for i,v in ipairs(parts) do
            if v[1]:get_id() == SMODS.Ranks.queen.id then
                queen = true
                result[#result+1] = v
            end
        end
        for i,v in ipairs(hand) do
            if v:get_id() == 2 then
                two = true
                result[#result+1] = {v}
            end
        end
        return queen and two and result or {}
    end
}

SMODS.PokerHand{
    key = "Sisters",
    chips = 15,
    mult = 4,
    l_chips = 10,
    l_mult = 3,
    example = {
        { "C_2", true },
        { "S_3", false },
        { "S_2", true },
        { "D_Q", true },
        { "H_Q", true },
    },
    evaluate = function (parts, hand)
        local result = {}
        local queen, twos = false, false
        for i,v in ipairs(parts) do
            if v[1]:get_id() == SMODS.Ranks.queen.id then
                queen = true
                result[#result+1] = v
            end
            if v[1]:get_id() == 2 then
                twos = true
                result[#result+1] = v
            end
        end
        return queen and twos and result or {}
    end
}

SMODS.PokerHand{
    key = "Polythremian",
    chips = 20,
    mult = 3,
    l_chips = 15,
    l_mult = 3,
    example = {
        { "S_2", true },
        { "C_J", true },
        { "H_J", true },
        { "S_2", true },
        { "H_3", false },
    },
    evaluate = function (parts, hand)
        local result = {}
        local jack, twos = false, false
        for i,v in ipairs(parts) do
            if v[1]:get_id() == SMODS.Ranks.jack.id then
                jack = true
                result[#result+1] = v
            end
            if v[1]:get_id() == 2 then
                twos = true
                result[#result+1] = v
            end
        end
        return jack and twos and result or {}
    end
}