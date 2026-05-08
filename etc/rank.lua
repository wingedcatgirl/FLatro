local suit_map = {}
for k,v in pairs(SMODS.Suits) do
    suit_map[k] = 0
end

SMODS.Rank{
    key = "joker",
    card_key = "joker",
    nominal = 0,
    face = false,
    number = false,
    strength_effect = {
        ignore = true
    },
    suit_map = suit_map,
    in_pool = function (self, args)
        return false
    end
}