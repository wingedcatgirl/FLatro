SMODS.PokerHand{
    key = "Audit",
    chips = 25,
    mult = 3,
    l_chips = 15,
    l_mult = 3,
    example = {
        { "S_3", true },
        { "C_7", true },
        { "D_10", true },
        { "S_K", false },
        { "H_3", true },
    },
    evaluate = function (parts, hand)
        local cards = {}
        local suits = {}
        local count = 0
        for _,card in ipairs(hand) do
            if not card:is_face() and not SMODS.has_no_suit(card) then
                if SMODS.has_any_suit(card) then
                    cards[#cards+1] = card
                    count = count + 1
                else
                    for k,v in pairs(SMODS.Suits) do
                        if card:is_suit(k) then
                            if not suits[k] then
                                suits[k] = true
                                count = count + 1
                                break
                            end
                        end
                    end
                    cards[#cards+1] = card
                end
            end
        end
        if count >= 4 then return {cards} else return {} end
    end
}