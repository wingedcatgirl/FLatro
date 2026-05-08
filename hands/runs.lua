SMODS.PokerHand{
    key = "Retreat",
    chips = 25,
    mult = 3,
    l_chips = 10,
    l_mult = 3,
    example = {
        { "S_9", true },
        { "D_8", false },
        { "S_10", true },
        { "C_3", false },
        { "S_J", true },
    },
    evaluate = function (parts, hand)
        local run = get_straight(hand, 3, SMODS.shortcut())
        local faces, nonfaces = 0,0
        for i,v in ipairs(run) do
            if v:is_face() then faces = faces + 1 else nonfaces = nonfaces + 1 end
        end
        if faces ~= 1 or nonfaces < 2 then return {} end
        return {run}
    end
}