do return end

SMODS.PokerHand{
    key = "Handname",
    chips = 25,
    mult = 3,
    above_hand = "marv_HAND",
    l_chips = 15,
    l_mult = 3,
    example = {
        { "S_3", true },
        { "C_7", true },
        { "D_T", true },
        { "S_K", false },
        { "H_3", true },
    },
    evaluate = function (parts, hand)
        
    end
}